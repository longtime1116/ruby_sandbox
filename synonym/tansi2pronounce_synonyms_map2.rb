require "csv"
require "json"
require "pp"

INPUT_DIR = "./input".freeze
INPUT_TANSI_TSV  = "#{INPUT_DIR}/tansi_test.tsv".freeze
#INPUT_TANSI_TSV  = "#{INPUT_DIR}/tansi.tsv".freeze

OUTPUT_DIR = "./output".freeze
OUTPUT_SYNONYMS_LIST_COLLECTION_TXT = "#{OUTPUT_DIR}/test1.txt".freeze

def parse_tansi_tsv(input_file)
  CSV.read(input_file, :col_sep => "\t")
    .select {|data| data.size != 0}
    .map do |data|
    [data[0], data[1], data[5].split("/")] # ["師資", "シシ", ["師資", "シシ", "しし"]],
  end
end

def sort_by_pronounce(tansi_records)
  tansi_records.sort {|a, b| a[1] <=> b[1]}
end

def sort_by_word(tansi_records)
  tansi_records.sort {|a, b| a[0] <=> b[0]}
end

def pronounces_of(data)
  data.map { |d| d[1] }.uniq
end

def find_same_start_index(sorted_records, index, position)
  index.downto(0) do |i|
    return 0 if i == 0
    return i + 1 if sorted_records[i][position] != sorted_records[index][position]
  end
end

def find_same_last_index(sorted_records, index, position)
  upper_bound = sorted_records.size - 1
  index.upto(sorted_records.size) do |i|
    return upper_bound if i == upper_bound
    return i - 1 if sorted_records[i][position] != sorted_records[index][position]
  end
end

def find_same_index_range(sorted_records, index, position)
  pronounce = sorted_records[index]
  start = find_same_start_index(sorted_records, index, position)
  last = find_same_last_index(sorted_records, index, position)
  [start, last]
end

def find_same_records(pronounce, pronounce_sorted_records, position)
  index = pronounce_sorted_records.map{|record| record[position]}.bsearch_index{|x, _| x >= pronounce}
  start, last = find_same_index_range(pronounce_sorted_records, index, position)
  pronounce_sorted_records[start..last]
end

def find_same_word_records(word, word_sorted_records)
  word_sorted_records.select {|record| record[0] == word}
end

def find_related_pronounces_r(all_pronounces, pronounces, tansi_records, pronounce_sorted_records, word_sorted_records)
  return [] if pronounces.empty?
  return [] if (pronounces - all_pronounces).empty?

  all_pronounces.concat(pronounces).uniq

  other_pronounces = []
  pronounces.each do |pronounce|
    same_pronounce_records = find_same_records(pronounce, pronounce_sorted_records, 1)
    same_pronounce_records.each do |word|
      other_pronounces.concat(pronounces_of(find_same_records(word[0], word_sorted_records, 0)))
    end
  end

  other_pronounces = (other_pronounces - all_pronounces).uniq
  pronounces + find_related_pronounces_r(all_pronounces, other_pronounces, tansi_records, pronounce_sorted_records, word_sorted_records)
end

def find_related_pronounces(pronounce, tansi_records, pronounce_sorted_records, word_sorted_records)
  find_related_pronounces_r([], [pronounce], tansi_records, pronounce_sorted_records, word_sorted_records)
end

def build_pronounce_synonyms_map(pronounces, pronounce_sorted_records)
  pronounces.map do |pronounce|
    {
      pronounce: pronounce,
      synonyms_list: find_same_records(pronounce, pronounce_sorted_records, 1)
      .map  { |record| { word: record[0], synonyms: record[2] } }
    }
  end
end

def tansi2pronounce_synonyms_map_list(input_file, output_file)
  tansi_records = parse_tansi_tsv(input_file)

  pronounce_sorted_records = sort_by_pronounce(tansi_records)
  word_sorted_records = sort_by_word(tansi_records)
  processed_pronounces = []

  #pp tansi_records
  #pp pronounce_sorted_records
  #pp word_sorted_records
  total_pronounce_count = pronounces_of(tansi_records).count
  File.open(OUTPUT_SYNONYMS_LIST_COLLECTION_TXT, "w") do |file|
    pronounces_of(tansi_records).each do |pronounce|
      next if processed_pronounces.include?(pronounce)

      # 辿れる発音を芋づる式にとってくる
      pronounces = find_related_pronounces(pronounce, tansi_records, pronounce_sorted_records, word_sorted_records)

      # 辿れる発音とそれに紐づくシノニムはひとまとめにしてまとめてファイルに書き出す
      pronounce_synonyms_map = build_pronounce_synonyms_map(pronounces, pronounce_sorted_records)
      file.puts(pronounce_synonyms_map.to_json)

      processed_pronounces.concat(pronounces)
      p "#{processed_pronounces.count}/#{total_pronounce_count} #{processed_pronounces.count.to_f/total_pronounce_count * 100}%(#{Time.now})"
      break if processed_pronounces.count > 100
    end
  end
end

start_time = Time.now
puts "処理開始 #{start_time}"
tansi2pronounce_synonyms_map_list(INPUT_TANSI_TSV, OUTPUT_SYNONYMS_LIST_COLLECTION_TXT)
end_time = Time.now
puts "処理終了 #{end_time}"
puts "処理時間 #{end_time - start_time}s"

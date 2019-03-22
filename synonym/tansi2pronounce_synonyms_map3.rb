require "csv"
require "json"
require "pp"

INPUT_DIR = "./input".freeze
#INPUT_TANSI_TSV  = "#{INPUT_DIR}/tansi_test.tsv".freeze
INPUT_TANSI_TSV  = "#{INPUT_DIR}/tansi.tsv".freeze

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
  records = tansi_records.sort {|a, b| a[1] <=> b[1]}
  [records, records.map {|record| record[1]}]
end

def sort_by_word(tansi_records)
  records = tansi_records.sort {|a, b| a[0] <=> b[0]}
  [records, records.map {|record| record[0]}]
end

def pronounces_of(records)
  records.map { |d| d[1] }.uniq
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
  start = find_same_start_index(sorted_records, index, position)
  last = find_same_last_index(sorted_records, index, position)
  [start, last]
end

def find_same_records(element, sorted_records, sorted_elements, position)
  index = sorted_elements.bsearch_index{|x, _| x >= element}
  start, last = find_same_index_range(sorted_records, index, position)
  sorted_records[start..last]
end

def find_same_word_records(word, word_sorted_records)
  word_sorted_records.select {|record| record[0] == word}
end

def find_related_pronounces_r(processed_pronounces, pronounces, tansi_records, pronounce_sorted_records, sorted_pronounces, word_sorted_records, sorted_words)
  return [] if pronounces.empty?
  return [] if (pronounces - processed_pronounces).empty?

  processed_pronounces.concat(pronounces).uniq

  other_pronounces = []
  pronounces.each do |pronounce|
    same_pronounce_records = find_same_records(pronounce, pronounce_sorted_records, sorted_pronounces, 1)
    same_pronounce_records.each do |word|
      other_pronounces.concat(pronounces_of(find_same_records(word[0], word_sorted_records, sorted_words, 0)))
    end
  end

  other_pronounces = (other_pronounces - processed_pronounces).uniq
  pronounces + find_related_pronounces_r(processed_pronounces, other_pronounces, tansi_records, pronounce_sorted_records, sorted_pronounces, word_sorted_records, sorted_words)
end

def find_related_pronounces(pronounce, tansi_records, pronounce_sorted_records, sorted_pronounces, word_sorted_records, sorted_words)
  find_related_pronounces_r([], [pronounce], tansi_records, pronounce_sorted_records, sorted_pronounces, word_sorted_records, sorted_words)
end

def build_pronounce_synonyms_map(pronounces, pronounce_sorted_records, sorted_pronounces)
  pronounces.map do |pronounce|
    {
      pronounce: pronounce,
      synonyms_list: find_same_records(pronounce, pronounce_sorted_records, sorted_pronounces, 1)
      .map  { |record| { word: record[0], synonyms: record[2] } }
    }
  end
end

def tansi2pronounce_synonyms_map_list(input_file, output_file)
  tansi_records = parse_tansi_tsv(input_file)

  pronounce_sorted_records, sorted_pronounces = sort_by_pronounce(tansi_records)
  word_sorted_records, sorted_words = sort_by_word(tansi_records)
  processed_pronounces = []

  #pp tansi_records
  #pp pronounce_sorted_records
  #pp word_sorted_records
  all_pronounces = pronounces_of(pronounce_sorted_records)
  total_pronounce_count = all_pronounces.count
  File.open(OUTPUT_SYNONYMS_LIST_COLLECTION_TXT, "w") do |file|
    all_pronounces.each do |pronounce|
      next if processed_pronounces.include?(pronounce)

      # 辿れる発音を芋づる式にとってくる
      pronounces = find_related_pronounces(pronounce, tansi_records, pronounce_sorted_records, sorted_pronounces, word_sorted_records, sorted_words)

      # 辿れる発音とそれに紐づくシノニムはひとまとめにしてまとめてファイルに書き出す
      pronounce_synonyms_map = build_pronounce_synonyms_map(pronounces, pronounce_sorted_records, sorted_pronounces)
      file.puts(pronounce_synonyms_map.to_json)

      processed_pronounces.concat(pronounces)
      p "#{processed_pronounces.count}/#{total_pronounce_count} #{processed_pronounces.count.to_f/total_pronounce_count * 100}%(#{Time.now})"
    end
  end
end

start_time = Time.now
puts "処理開始 #{start_time}"
tansi2pronounce_synonyms_map_list(INPUT_TANSI_TSV, OUTPUT_SYNONYMS_LIST_COLLECTION_TXT)
end_time = Time.now
puts "処理終了 #{end_time}"
puts "処理時間 #{end_time - start_time}s"

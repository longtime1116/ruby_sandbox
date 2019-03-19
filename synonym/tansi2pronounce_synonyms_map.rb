require "csv"
require "json"
require "pp"

INPUT_DIR = "./input".freeze
INPUT_TANSI_TSV  = "#{INPUT_DIR}/tansi_test.tsv".freeze
#INPUT_TANSI_TSV  = "#{INPUT_DIR}/tansi.tsv".freeze

OUTPUT_DIR = "./output".freeze
OUTPUT_SYNONYMS_LIST_COLLECTION_TXT = "#{OUTPUT_DIR}/test1.txt".freeze

def parse_tansi_tsv(input_file)
  CSV.read(input_file, :col_sep => "\t").map {|data| {word: data[0], pronounce: data[1], synonyms: data[5].split("/")} unless data.size == 0}.compact
end

def pronounces_of(data)
  data.flatten.map { |d| d[:pronounce] }.uniq
end

def find_related_pronounces_r(all_pronounces, pronounces, tansi_records)
  return [] if pronounces.empty?
  return [] if (pronounces - all_pronounces).empty?

  all_pronounces.concat(pronounces).uniq

  other_pronounces = []
  pronounces.each do |pronounce|
    same_pronounce_words = tansi_records.select {|record| record[:pronounce] == pronounce}
    same_pronounce_words.each do |word|
      other_pronounces.concat(pronounces_of(tansi_records.select {|record| record[:word] == word[:word] }))
    end
  end

  other_pronounces = (other_pronounces - all_pronounces).uniq
  pronounces + find_related_pronounces_r(all_pronounces, other_pronounces, tansi_records)
end

def find_related_pronounces(pronounce, tansi_records)
  find_related_pronounces_r([], [pronounce], tansi_records)
end

def build_pronounce_synonyms_map(pronounces, tansi_records)
  pronounces.map do |pronounce|
    {
      pronounce: pronounce,
      synonyms_list: tansi_records
      .select { |record| record[:pronounce] == pronounce }
      .map  { |record| { word: record[:word], synonyms: record[:synonyms] } }
    }
  end
end

def tansi2pronounce_synonyms_map_list(input_file, output_file)
  tansi_records = parse_tansi_tsv(input_file)
  processed_pronounces = []

  total_pronounce_count = pronounces_of(tansi_records).count
  File.open(OUTPUT_SYNONYMS_LIST_COLLECTION_TXT, "w") do |file|
    pronounces_of(tansi_records).each do |pronounce|
      next if processed_pronounces.include?(pronounce)

      # 辿れる発音を芋づる式にとってくる
      pronounces = find_related_pronounces(pronounce, tansi_records)

      # 辿れる発音とそれに紐づくシノニムはひとまとめにしてまとめてファイルに書き出す
      pronounce_synonyms_map = build_pronounce_synonyms_map(pronounces, tansi_records)
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

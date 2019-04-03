require "pp"
def similar_items_excluding_shown_series_items(similar_items, series_items, max_shown_items_count)
  return if similar_items.empty?
  return similar_items.take(max_shown_items_count) if series_items.empty?

  similar_item_ids = similar_items.map{|similar_item| similar_item["id"]}
  series_item_ids = series_items.map{|series_item| series_item["id"]}

  ids_of_similar_items_excluding_series_items = similar_item_ids - series_item_ids

  # 類似素材からシリーズ素材を除外したものが類似素材欄の最大表示件数に満たない場合、表示対象外のシリーズ素材を末尾に追加する。
  ids_of_similar_items_excluding_shown_series_items =
    if ids_of_similar_items_excluding_series_items.size < max_shown_items_count
      (ids_of_similar_items_excluding_series_items).concat(series_item_ids[max_shown_items_count..-1] ||= [])
    else
      ids_of_similar_items_excluding_series_items
    end
      .take(max_shown_items_count)

    similar_items_excluding_shown_series_items = []

    ids_of_similar_items_excluding_shown_series_items.map do |id|
      similar_items.each do |similar_item|
        if similar_item["id"] == id
          similar_items_excluding_shown_series_items << similar_item
          break
        end
      end
    end

    similar_items_excluding_shown_series_items
end

def build_single_hash(num)
  hash = {}
  50.times do |i|
    hash["#{i}"] = i
  end
  hash["id"] = num
  hash
end

def build_similar_items
  (1..210).map do |num|
    build_single_hash(num)
  end
end

# id が 1〜10
def build_series_items
  (1..10).map do |num|
    build_single_hash(num)
  end
end

similar_items = build_similar_items
series_items = build_series_items
max_shown_items_count = 7


idx = 0
100000.times do
  similar_items_excluding_shown_series_items(similar_items, series_items, max_shown_items_count)
  idx += 1

  if idx % 1000 == 0
    p("#{idx/1000}/100")
  end
end
#p build_single_hash(101)
#pp build_similar_items

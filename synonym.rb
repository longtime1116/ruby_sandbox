# 前提: 以下が真であるとする
# 同音異義語である <=> 3つ以上の集合に含まれる

def select_target_word(list)
  # keyword planner 的なやつ
  "赤"
end

def get_lists_without_homonyms(xxx, homonyms)
  # xxx は keyつきの lists
  # key つきの lists から、homonyms が key になっているものを覗き、value だけの配列を返す
  [
    ["赤", "あか", "アカ"],
    ["垢", "あか", "アカ"],
    ["朱", "あか", "アカ"],
    ["淦", "あか", "アカ"],
  ]
end


lists = [
  ["赤", "あか", "アカ"],
  ["垢", "あか", "アカ"],
  ["朱", "あか", "アカ"],
  ["淦", "あか", "アカ"],
  ["赤", "垢", "朱", "淦", "あか", "アカ"],
  ["赤", "垢", "朱", "淦", "あか", "アカ"]
]

words = []
homonyms = []

lists.each do |list|
  list.each do |word|
    if words.count(word) > 2 && !homonyms.include?(word)
      homonyms << word
    end
    words << word
  end
end
p "words"
p words # ["赤", "あか", "アカ", "垢", "あか", "アカ", "朱", "あか", "アカ", "淦", "あか", "アカ", "赤", "垢", "朱", "淦", "あか", "アカ", "赤", "垢", "朱", "淦", "あか", "アカ"]
p "homonyms"
p homonyms # ["あか", "アカ"]

lists_without_homonyms = get_lists_without_homonyms([], homonyms)

p "lists_without_homonyms"
p lists_without_homonyms # [["赤", "あか", "アカ"], ["垢", "あか", "アカ"], ["朱", "あか", "アカ"], ["淦", "あか", "アカ"]]

homonym_candidates_map = {}
homonyms.each do |homonym|
  lists_without_homonyms.each do |list|
    if list.include?(homonym)
      homonym_candidates_map[homonym] = [] if homonym_candidates_map[homonym].nil?
      list.each do |word|
        homonym_candidates_map[homonym] << word if !homonyms.include?(word) && !homonym_candidates_map[homonym].include?(word)
      end
    end
  end
end

p "homonym_candidates_map"
p homonym_candidates_map # {"あか"=>["赤", "垢", "朱", "淦"], "アカ"=>["赤", "垢", "朱", "淦"]}

lists_excluding_homonyms = []
lists_without_homonyms.each do |list|
  tmp = list.dup
  list.each do |word|
    tmp.delete(word) if homonyms.include?(word)
  end
  lists_excluding_homonyms << tmp
end

p "lists_excluding_homonyms"
p lists_excluding_homonyms # [["赤"], ["垢"], ["朱"], ["淦"]]

homonym_candidates_map.each_pair do |key, value|
  target = select_target_word(value)
  lists_excluding_homonyms.each do |words|
    words << key if words.include?(target)
  end
end

p "lists_excluding_homonyms"
p lists_excluding_homonyms


# homonym_candidates_map と、lists_excluding_homonyms と、ketword planner があれば、いけるかも

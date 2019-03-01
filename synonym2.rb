def hirakata?(word)
  return true if word.match(/^\p{hiragana}*$/)
  return true if word.match(/^\p{katakana}*$/)
  false
end

###########

def harahara?(hashes)
  hashes.map {|hash| hash[:key]}.all? { |s| hirakata?(s) }
end

def harahara_pattern(hashes)
  [hashes.reduce([]) {|array, hash| array.push(hash[:key]) }]
end

def hanafuda?(hashes)
end

def hanafuda_pattern(hashes)
end

def to_synonym(words)
  # 汎用好みの分類(はらはら)
  return harahara_pattern(words) if harahara?(words)

  # 単体の分類(花札)
  return hanafuda_pattern if hanafuda?(words)

  ## 同音系の完全系(赤、受け渡し)
  #return aka_pattern if aka?(words)
  ## 歯抜けしか残っていない"はず"
  #to_barabara(words)
end


harahara = [
  {key: "はらはら", synonyms:  ["はらはら", "ハラハラ"]},
  {key: "ハラハラ", synonyms:  ["はらはら", "ハラハラ"]},
]
harahara_answer =[["はらはら", "ハラハラ"]]

harahara2 = [
  {key: "はらはら", synonyms:  ["はらはら", "ハラハラ"]},
  {key: "ハラハラ", synonyms:  ["ハラハラ"]},
]
harahara2_answer =[["はらはら", "ハラハラ"]]

hanafuda = [
  {key: "はなふだ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "ハナフダ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "花札",     synonyms:  ["はなふだ", "ハナフダ", "花札"]},
]
hanafuda_answer =[["はらはら", "ハラハラ"]]

aka = [
  {key: "", synonyms:  ["あか", "赤", "垢"]},
  {key: "", synonyms:  ["あか", "赤"]},
  {key: "", synonyms:  ["あか", "垢"]},
]
aka_answer =[["はらはら", "ハラハラ"]]


p to_synonym(harahara) == harahara_answer
p to_synonym(hanafuda) == hanafuda_answer
p to_synonym(aka) == aka_answer




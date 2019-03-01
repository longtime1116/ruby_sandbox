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
  hashes.map {|hash| hash[:key]}.delete_if {|s| s.match(/^\p{hiragana}*$/) || s.match(/^\p{katakana}*$/)}.uniq.size == 1
end

def hanafuda_pattern(hashes)
  [hashes.map {|hash| hash[:key]}.uniq]
end

def uke?(hashes)

end

def uke_pattern(hashes)

end

def aka?(hashes)

end

def aka_pattern(hashes)

end

def uke?(hashes)
  # synonyms が完全一致した時に、
end


def to_synonym(hashes)
  # 汎用好みの分類(はらはら)
  p "harahara"
  return harahara_pattern(hashes) if harahara?(hashes)

  # 単体の分類(花札)
  p "hanafuda"
  return hanafuda_pattern(hashes) if hanafuda?(hashes)

  # 同音系の完全系(赤、受け渡し)
  p "uke"
  return uke_pattern if uke?(hashes)

  ## 歯抜けしか残っていない"はず"
  #to_barabara(hashes)
  return "not match"
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
  {key: "花札",     synonyms:  ["はなふだ", "ハナフダ", "花札"]},
]
hanafuda_answer = [["はなふだ", "ハナフダ", "花札"]]

uke = [
    {key: "うけわたし", synonyms:  ["うけわたし", "受けわたし", "受け渡"]},
    {key: "受けわたし", synonyms:  ["うけわたし", "受けわたし", "受け渡"]},
    {key: "受け渡",     synonyms:  ["うけわたし", "受けわたし", "受け渡"]},
]
uke_answer =[["うけわたし", "受けわたし", "受け渡"]]

aka = [
  {key: "あか", synonyms:  ["あか", "赤", "垢"]},
  {key: "赤", synonyms:  ["あか", "赤"]},
  {key: "垢", synonyms:  ["あか", "垢"]},
]
aka_answer =[["あか", "赤"], ["垢"]]

ukehanuke = [
    {key: "うけわたし", synonyms:  ["うけわたし", "受けわたし", "受け渡", "受渡"]},
    {key: "受けわたし", synonyms:  ["うけわたし", "受けわたし", "受け渡", "受渡"]},
    {key: "受け渡",     synonyms:  ["うけわたし", "受けわたし", "受け渡", "受渡"]},
    {key: "受渡",       synonyms:  ["うけわたし", "受けわたし", "受渡"]},
]
ukehanuke_answer =[["うけわたし", "受けわたし", "受け渡"], ["受渡"]]


p to_synonym(harahara) == harahara_answer
p to_synonym(hanafuda) == hanafuda_answer
p to_synonym(uke) == uke_answer
p to_synonym(aka) == aka_answer
p to_synonym(ukehanuke) == ukehanuke_answer




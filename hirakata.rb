def hirakata?(word)
  return true if word.match(/^\p{hiragana}*$/)
  return true if word.match(/^\p{katakana}*$/)
  false
end

harahara = [
  {key: "はらはら", synonyms:  ["はらはら", "ハラハラ"]},
  {key: "ハラハラ", synonyms:  ["ハラハラ"]},
]

harahara.each {|hash| p hash[:key]}
p harahara.map {|hash| hash[:key]}.all? { |s| hirakata?(s) }

p hirakata?("はらはら")
p hirakata?("ハラハラ")
p hirakata?("はらハラ")
p hirakata?("苦ハラ")

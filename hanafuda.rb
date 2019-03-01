def hanafuda?(hashes)
  hashes.map {|hash| hash[:key]}.delete_if {|s| s.match(/^\p{hiragana}*$/) || s.match(/^\p{katakana}*$/)}.uniq.size == 1
end

hanafuda = [
  {key: "はなふだ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "ハナフダ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "花札",     synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "花札",     synonyms:  ["はなふだ", "ハナフダ", "花札"]},
]
hanafuda2 = [
  {key: "はなふだ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "ハナフダ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "花札",     synonyms:  ["はなふだ", "ハナフダ", "花札"]},
]
hanafuda3 = [
  {key: "はなふだ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "ハナフダ", synonyms:  ["はなふだ", "ハナフダ", "花札"]},
  {key: "花札",     synonyms:  ["はなふだ", "花札"]},
]
aka = [
  {key: "あか", synonyms:  ["あか", "赤", "垢"]},
  {key: "赤", synonyms:  ["あか", "赤"]},
  {key: "垢", synonyms:  ["あか", "垢"]},
]

p hanafuda?(hanafuda)
p hanafuda?(hanafuda2)
p hanafuda?(hanafuda3)
p hanafuda?(aka)

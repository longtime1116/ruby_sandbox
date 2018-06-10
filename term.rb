require "term"

t1 = Term.new(from: "2018-01-01", to: "2019-01-01")
t2 = Term.new(from: "2018-06-01", to: "2019-06-01")

p t1.from
p t1.to
p t1.overlap_with?(t2)
p t1.overlap_with(t2)

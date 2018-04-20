def multi1
  [1, 2]
end

#def multi2
#  1, 2
#end

begin
  hoge, geho = multi1
  p hoge
  p geho
rescue => e
  p e
end

#begin
#  hoge, geho = multi2
#  p hoge
#  p geho
#rescue => e
#  p e
#end




############################################


def multi3
  {subscription: 1, term_number: 2}
end

begin
  sub = multi3[:subscription]
  term_number = multi3[:term_number]
  p sub
  p term_number
end

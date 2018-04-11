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

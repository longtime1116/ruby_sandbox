require "uri"
require "csv"

zh = "亢"
jp = "あ"

p "zh original: "+ zh
p "jp original: "+ jp

zh_encoded = URI.encode(zh)
jp_encoded = URI.encode(jp)

p "zh encoded: "+ zh_encoded
p "jp encoded: "+ jp_encoded

zh_decoded = URI.decode(zh_encoded)
jp_decoded = URI.decode(jp_encoded)

p "zh decoded: " + zh_decoded
p "jp decoded: " + jp_decoded



p "output zh original"
CSV.open("./zh1.csv", "w") do |csv|
  csv << [zh]
end
p "done"

p "output jp original"
CSV.open("./jp1.csv", "w") do |csv|
  csv << [jp]
end
p "done"

#p "output decoded zh"
#p zh_decoded.ord
#CSV.open("./zh2.csv", "w") do |csv|
#  csv << [zh_decoded]
#end
#p "done"

p "output decoded jp"
CSV.open("./jp2.csv", "w") do |csv|
  csv << [jp_decoded]
end
p "done"


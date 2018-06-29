require "pdf-reader"

reader = PDF::Reader.new("soron.pdf")

reader.pages.each do |page|
  puts page.text
end

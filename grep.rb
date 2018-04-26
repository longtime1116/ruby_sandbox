hoge = ["adam", "bob", 3, "bot", "buu"].grep(/^bo/) do |element|
  element.gsub((/bo/), "po")
end
p hoge

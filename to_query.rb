require 'active_support'
require 'active_support/core_ext'

hoge = {b: 1, a: 2}
p hoge.to_query

geho = hoge.collect do |key, value|
  unless (value.is_a?(Hash) || value.is_a?(Array)) && value.empty?
    value.to_query(key)
  end
end.compact.sort! * '&'

p geho

gehoho = hoge.collect do |key, value|
  unless (value.is_a?(Hash) || value.is_a?(Array)) && value.empty?
    value.to_query(key)
  end
end.compact * '&'

p gehoho

module Mod
  def bbbb
    p "bbbb"
  end
end

module Foo
  extend Mod
  def aaa
    p "aaa"
    Bar.hoge
  end

  module Bar
    extend Mod
    def self.hoge
      p "hoge"
      bbbb
    end
  end
end

class Test
  include Foo
end

Test.new.aaa

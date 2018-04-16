class Hoge1
  def hoge
    p "hoge1"
  end

  def foo(bar)
    p bar
  end
end

class Hoge2 < Hoge1
  def hoge
    return super if true
  end

  def foo(bar)
    # 引数なしで super を呼び出しても、引数は渡される
    return super if true
  end
end

Hoge2.new.hoge #=> hoge1
Hoge2.new.foo("foo") #=> foo

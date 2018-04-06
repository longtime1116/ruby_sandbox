class Person
  def initialize(name, age)
    @name = name
    @age = age
  end

  def age
    @age
  end
end

class Foo
  attr_accessor :address
  def initialize
    @address = "funny"
  end
  def totalhoge(hoge1, hoge2, hoge3, hoge4)
    tom = "tom"
    [hoge1, hoge2, hoge3, hoge4].reduce(0) do |total, person|
      p tom
      p address
      total + aaa(person.age)
    end
  end

  private

  def aaa(num)
      num * 2
  end
end

hoge1 = Person.new("hoge1", 21)
hoge2 = Person.new("hoge2", 22)
hoge3 = Person.new("hoge3", 23)
hoge4 = Person.new("hoge4", 24)


foo = Foo.new

p foo.totalhoge(hoge1, hoge2, hoge3, hoge4)

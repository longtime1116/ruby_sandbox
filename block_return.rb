def foo(x)
  x.times do|i|
    return i
  end
end

p foo(42)

def bar(x)
  x.times &-> (i) do
    return i
  end
end

p bar(42)

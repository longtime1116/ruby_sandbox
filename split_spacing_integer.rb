def split(arrays, i)
  return arrays if arrays[0].length < i+2
  if arrays[0][i+1] - arrays[0][i] > 1
    return [arrays[0][0..i]] + split([arrays[0][i+1..-1]], 0)
  end
  split(arrays, i + 1)
end

p split([[1, 2, 3, 5, 7, 8, 9]], 0) # [[1, 2, 3], [5], [7, 8, 9]]

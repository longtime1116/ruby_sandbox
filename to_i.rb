# to_i は先頭からparseしていって数字以外が出るまでとる


p "10aaa22".to_i # => 10
p "a10aaa22".to_i # => 0

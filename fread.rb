start_line_no = 5
read_num = 4

File.open("./sample.txt") do |f|
  # 読み捨て
  (start_line_no - 1).times {f.gets}

  read_num.times do
    line = f.gets
    p line
  end
end

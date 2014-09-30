puts `ls /dev/fd`

File.open("wat", "w") do |f|
  puts "opened #{f.fileno}"
  puts `ls /dev/fd`
end


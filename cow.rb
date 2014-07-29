
n = 1
n = 1000000
arr = []
n.times do |i|
  arr.push i
end

f = 10
f.times do
  fork {
    arr.map! {|a| a + 1 }
    pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
    puts "#{size}\n"
  }
end



f.times do
  Process.wait
end


pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)

puts "... and finally"
puts size
puts "done"

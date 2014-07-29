a = fork do
  5.times do
    sleep 1
    puts "I'm an orphan!"
  end
end

b = fork do
  puts "I'm a 2 orphan!"
end

#puts "i killed #{Process.wait2}"
puts Process.wait a

abort "Parent process died..."

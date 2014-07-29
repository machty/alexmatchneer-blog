
Thread.new {
  sleep 1
  puts 'wat'
}

Thread.new {
  sleep 2
  exec 'ls'
}

Thread.new {
  sleep 3
  puts "I LIVED"
}

sleep

#Thread.new {
  #Thread.current[:a] = "lol"
  #Fiber.new {
    #puts "in new fiber: #{Thread.current[:a]}"
  #}.resume
  #puts "in original fiber: #{Thread.current[:a]}"
#}.join


#Thread.new {
  #sleep 1
  #puts "OMG"
#}#.join
#puts "DONE"


pid = fork {
  sleep 1
  puts "im a forked process, my pid is #{Process.pid}"
}
puts "spawned process w #{pid}"


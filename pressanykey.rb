print "Press any key... "

Signal.trap(:INT) do
  puts "this doesn't fire"
end

begin
  system("stty raw -echo")
  c = STDIN.getc
ensure
  # re-enable
  system("stty -raw echo")
end

puts "oh shit"

puts c


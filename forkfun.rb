r, w = IO.pipe

if child_pid = fork
  r.close

  w.puts "you's a bitch"
  w.close
else
  w.close

  puts "message received: #{r.read}"
  r.close
end


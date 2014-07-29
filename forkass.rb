r,w = IO.pipe

if fork
  r.close
  w.write "shit\n"
  w.write "ass\n"
  w.close
  Process.wait
else
  w.close
  puts r.read
  puts r.read
  puts r.read
  puts "heh"
  r.close
end


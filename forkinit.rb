# Test that these get adopted by init

fork do
  loop do
    puts "(#{Process.pid}, #{Process.ppid})"
    sleep 1
  end
end

sleep 1

abort "k i'm done #{Process.pid}"

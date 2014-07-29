
puts Process.pid

fork {
  sleep 2
  puts Process.getpgrp
}

#Process.wait


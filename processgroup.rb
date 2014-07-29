puts Process.pid
puts Process.getpgrp

fork {
  puts Process.getpgrp
  fork {
    puts Process.getpgrp
    fork {
      puts Process.getpgrp
      fork {
        puts "CHANGING"
        Process.setsid
        puts Process.getpgrp
        fork {
          puts Process.getpgrp
        }
      }
    }
  }
}

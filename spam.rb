
#$stdout.sync = true

5.times do
  fork {
    loop do
      puts "FARTS\n"
    end
  }
end


5.times do
  Process.wait
end



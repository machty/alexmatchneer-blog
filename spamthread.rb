
#$stdout.sync = true

5.times do
  #fork {
    #loop do
      #puts "FARTS\n"
    #end
  #}

  Thread.new do
    loop do
      $stderr.puts "wat"
    end
  end
end


sleep
puts "done"



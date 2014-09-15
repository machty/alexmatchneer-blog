
unless fork
  Process.setsid
  puts "wat"
  unless fork
    Process.setsid
    unless fork
      Process.setsid
      unless fork
        Process.setsid
        sleep
      end
      sleep
    enk
    sleep
  end
  sleep
end



Process.wait

=begin
  99014
    99015
      99016

  kill -INT 99015

  99014
    99015 (ruby) wat?
  99016

  kill -INT 99015

  99016

  kill -INT 99016
=end



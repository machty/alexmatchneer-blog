has_ignored = false
Signal.trap(:TSTP) do
  if has_ignored
    Process.kill(:STOP, Process.getpgrp)
  else
    has_ignored = true
    puts "ignoring"
  end
end

sleep


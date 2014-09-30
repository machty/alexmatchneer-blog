Signal.trap(:CHLD) do
  begin
    Process.waitpid(-1, Process::WUNTRACED|Process::WNOHANG)
    puts $?.stopped?
    #pid = $?
    #puts "got some shit #{pid}"
  rescue Errno::ECHILD => e
    puts "no child processes (ignoring initial fork event)"
  end
end

fork do
  Process.kill(:STOP, Process.pid)
  puts "done"
end

Process.wait


puts "I am #{Process.pid}"

Signal.trap(:CONT) do
  puts "Awake"
end

Process.kill(:STOP, 0)

sleep


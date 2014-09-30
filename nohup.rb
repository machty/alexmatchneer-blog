Signal.trap(:HUP) do
  puts "I WILL NOT"
end

sleep


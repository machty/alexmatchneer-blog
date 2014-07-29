
keepgoing = true
trap(:INT) do
  keepgoing = false
end

while keepgoing
  puts "lol"
  sleep 0.5
end
puts "done"


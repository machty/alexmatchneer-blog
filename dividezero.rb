

trap(:FPE) do
  puts "you dingus"
end

puts "answer is"
puts 2/0 rescue ZeroDivisionError
puts "done"


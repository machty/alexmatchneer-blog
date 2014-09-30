require 'io/console'
console = IO.console
#console.write "wat"

console.raw do
  puts "wat"
end


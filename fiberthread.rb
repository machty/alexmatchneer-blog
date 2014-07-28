b = nil

t = Thread.new do
  b = Fiber.new {
    puts "FIBER"
  }
end

while !b
  # just wait
end

b.resume


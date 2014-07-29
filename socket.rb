require 'socket'

child_socket, parent_socket = Socket.pair(:UNIX, :DGRAM, 0)
maxlen = 1000

fork do
  parent_socket.close


  loop do
    instruction = child_socket.recv(maxlen)
    break if instruction == "wat"
    child_socket.send("#{instruction} accomplished!", 0)
  end
end
child_socket.close

2.times do
  parent_socket.send("Heavy lifting", 0)
end
2.times do
  parent_socket.send("Feather lifting", 0)
end

  #parent_socket.send("Feather lifting", 0)

4.times do
  $stdout.puts parent_socket.recv(maxlen)
end


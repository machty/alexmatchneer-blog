require 'socket'

=begin

socket = Socket.new(:INET, :STREAM)
addr = Socket.pack_sockaddr_in(4481, '0.0.0.0')
socket.bind(addr)

socket.listen(5)

while (a = socket.accept)
  #addr = a[1]
  #puts addr
  puts a[0].remote_address
end
=end

server = TCPServer.new(4481)

sleep 5

loop do
  conn, _ = server.accept
  puts "wat"
  conn.close
  #conn.shutdown
end



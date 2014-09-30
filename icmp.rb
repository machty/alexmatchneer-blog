require 'socket'
require 'base64'

rsock = Socket.open(:INET, :RAW)

loop do
  s = rsock.recv(1024)
  enc = Base64.encode64(s)
  puts enc
end




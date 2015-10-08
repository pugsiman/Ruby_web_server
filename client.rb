require 'socket'      # Sockets are in standard library

host = 'localhost'
port = 2000
path = '/index.html'

puts "What request method would you like to use, GET or POST?"
method = gets.chomp.upcase

case method
when 'GET'  then req = "GET #{path} HTTP/1.0\r\n\r\n"
when 'POST' then exit
end

socket = TCPSocket.open(host, port)
socket.print req

res = socket.read
print res

socket.close
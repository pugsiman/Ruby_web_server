require 'socket'
require 'json'

host = 'localhost'
port = 2005
path = '/'

puts 'What request method would you like to use, GET or POST?'
method = gets.chomp.upcase

case method
when 'GET'
  puts 'What file would you like to fetch?'
  path += gets.chomp.downcase
  path += '.html' unless path.include?('.html') # securing right format
  req = "GET #{path} HTTP/1.0\r\n\r\n"
when 'POST'
  puts "What's your favorite weapon?"
  weapon = gets.chomp.downcase
  puts "What's the viking name?"
  name = gets.chomp.downcase
  puts "What's your email?"
  email = gets.chomp.downcase
  viking = {:user => {:weapon => weapon, :name => name, :email => email}}
  jsond_viking = viking.to_json
  req = "POST /thanks.html HTTP/1.0" + "\nContent-Length: #{jsond_viking.length}\n\n#{jsond_viking}"
end

socket = TCPSocket.open(host, port)
socket.write req

res = socket.read
print res

socket.close

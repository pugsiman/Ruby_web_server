require 'socket'
require 'json'

port = 2005
server = TCPServer.open(port)

loop do
  # For threading use `Thread.start(server.accept) do |client|; end`
  puts 'Server initialized, waiting for incoming requests.'
  client = server.accept
  request = client.recvfrom(1024)
  puts request

  unless request.nil?
    request = request.join.strip.split
    method = request[0]
    path = request[1][1..-1]
    protocol = request[2]

    if method == 'GET' && File.file?(path)
      file = File.open(path).read
      content_length = file.length
      response = "#{protocol} 200 OK\n"\
                 "Server: ruby-server\n"\
                 "Content-Type: text/html; charset=utf-8\n"\
                 "Content-Length: #{content_length}\n"\
                 "Date: #{Time.now.ctime}\r\n\r\n"\
                 "#{file}"
      client.print response
    elsif method == 'POST' && File.file?(path)
      file = File.open(path).read
      params = JSON.parse(request.last)
      data = "<li>Name: #{params['user']['name']}</li>"\
             "<li>Email: #{params['user']['email']}</li>"
      content_length = file.gsub('<%= yield %>', data).length
      response = "#{protocol} 200 OK\n"\
                 "Content-Length: #{content_length}\n"\
                 "Date: #{Time.now.ctime}\r\n\r\n"\
                 "#{file.gsub('<%= yield %>', data)}"
      client.print response
    else
      response = "#{protocol} 404 NOT FOUND\r\n\r\n"
      client.print response
    end
  end
  client.close
end

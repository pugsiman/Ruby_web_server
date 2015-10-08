require 'socket'
require 'json'

port = 2005
server = TCPServer.open(port)

loop do
  # For threading use `Thread.start(server.accept) do |client|; end`
  client = server.accept
  request = client.recvfrom(1024)
  puts request

  unless request.nil?
    request = request.join.strip.split
    method = request[0]
    path = request[1][1..-1]
    protocol = request[2]

    if method == 'GET' && File.file?(path)
      body = File.open(path)
      content_length = File.read(path).length
      response = "#{protocol} 200 OK\n"\
                 "Content-Length: #{content_length}\n"\
                 "Date: #{Time.now.ctime}\r\n\r\n#{body.read}"
      client.print response
    elsif method == 'POST' && File.file?(path)
      body = File.open(path)
      content_length = request.last.length
      params = JSON.parse(request.last)     

      data = "<li>Name: #{params['user']['name']}</li>\n\t"\
             "<li>Email: #{params['user']['email']}</li>"
      response = "#{protocol} 200 OK\n"\
                 "#{Time.now.ctime}\n"\
                 "Content length: #{content_length}\r\n\r\n"\
                 "#{body.read.gsub('<%= yield %>', data)}"
      client.print response
    else
      response = "#{protocol} 404 NOT FOUND\r\n\r\n"
      client.print response
    end
  end
  client.close
end

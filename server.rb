require 'socket'

port = 2000
server = TCPServer.open(port)

loop do
  # For threading use `Thread.start(server.accept) do |client|; end`
  client = server.accept
  request = client.gets.split
  response = ""

  # initial line
  method = request[0]
  path = request[1][1..-1]
  protocol = request[2]

  if method == "GET" && path == "index.html"
    body = File.open(path)
    content_length = File.read(path).length
    response = "HTTP/1.0 200 OK\nContent-Length: #{content_length}\n"\
               "Date: #{Time.now.ctime}\r\n\r\n#{body.read}"
    client.print response
  else
    response = "#{protocol} 404 NOT FOUND\r\n\r\n"
    client.print response
  end
  client.close
end

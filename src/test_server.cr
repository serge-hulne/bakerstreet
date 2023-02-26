require "http/server"
require "./bakerstreet"
require "../archive.cr"

HOST = "127.0.0.1"
PORT = 8080
DEBUG = true

# Server using URL to archive path mapping
bk = BakerStreetArchive.new("myapp/dist")
arc = get_archive()

server = HTTP::Server.new do |context|
  # Mime type according to file type
  if context.request.path.ends_with?(".html")
    context.response.content_type = "text/html"
  elsif context.request.path.ends_with?(".css")
    context.response.content_type = "text/css"
  elsif context.request.path.ends_with?(".svg")
    context.response.content_type = "image/svg+xml"
  elsif context.request.path.ends_with?(".js")
    context.response.content_type = "text/javascript"
  end
  # Server response
  context.response.print bk.get_file_from_url?(context.request.path, bk, arc)
  if DEBUG
    puts "accessed : #{context.request.path}"
  end
end

# Running server
if DEBUG
  puts "Listening on http://#{HOST}:#{PORT}"
end
server.bind_tcp HOST, PORT
server.listen

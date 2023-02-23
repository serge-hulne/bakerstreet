require "../archive.cr"
require "./bakerstreet"
require "http/server"

HOST = "127.0.0.1"
PORT = 8080

# Read archive
Arc = get_archive()

# URL to archive path mapping
def get_file_from_url?(url : String) : String
  if url == "/" || url == ""
    url = "/index.html"
  end
  begin
    content = Arc[Baker.to_path(url)]
    return content
  rescue exception
    return "File not found: #{Baker.to_path(url)}"
  end
end

# Server using URL to archive path mapping
server = HTTP::Server.new do |context|
  context.response.print get_file_from_url?(context.request.path)
end

# Running server
puts "Listening on http://#{HOST}:#{PORT}"
server.bind_tcp HOST, PORT
server.listen

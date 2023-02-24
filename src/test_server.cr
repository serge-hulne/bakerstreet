require "http/server"
require "./bakerstreet"
require "../archive.cr"

HOST = "127.0.0.1"
PORT = 8080

# URL to archive path mapping
def get_file_from_url?(url : String, bk, arc) : String
  if url == "/" || url == ""
    url = "/index.html"
  end
  begin
    content = arc[bk.to_path(url)]
    return content
  rescue exception
    return "File not found: #{bk.to_path(url)}"
  end
end

# Server using URL to archive path mapping
server = HTTP::Server.new do |context|
  bk = Baker.new("public")
  arc = get_archive()
  context.response.print get_file_from_url?(context.request.path, bk, arc)
end

# Running server
puts "Listening on http://#{HOST}:#{PORT}"
server.bind_tcp HOST, PORT
server.listen


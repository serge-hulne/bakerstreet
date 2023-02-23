require "../archive.cr"
require "./bakerstreet"

arc = get_archive()
puts "file = #{arc[Baker.to_path("index.html")]}"

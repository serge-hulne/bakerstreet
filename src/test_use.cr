require "../archive.cr"
require "./bakerstreet"

bk = Baker.new("public")
arc = get_archive()

content = arc[bk.to_path("index.html")]
puts "file = #{content}"

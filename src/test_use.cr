require "../archive.cr"
require "./bakerstreet"

bk = BakerStreetArchive.new("myapp/dist")
arc = get_archive()

content = arc[bk.to_path("index.html")]
puts "file = #{content}"

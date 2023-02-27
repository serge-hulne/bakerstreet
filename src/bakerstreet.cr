require "path"
require "dir"

# TODO replace \n by a portable (OS dependent) newline symbol
# TODO Test on Windows.

# class BakerStreetArchive
class BakerStreetArchive
  def initialize(root : String)
    @root = root
    @root_path = Path.new(@root)
    @dico = Hash(String, String).new
    @arc = "archive.cr"
  end

  def to_path(file)
    # return @root_path.join(file).to_s
    return @root_path.to_s + file.to_s
  end

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

  # initialise the dictionary
  def walk_files_and_directories(directory : String)
    Dir.each_child(directory) do |entry|
      path = File.join(directory, entry)
      if File.directory?(path)
        walk_files_and_directories(path)
      else
        content = File.read(path)
        @dico[path.to_s] = content
      end
    end
  end

  # write dictionary
  def make_archive
    walk_files_and_directories(@root)
    buffer  = IO::Memory.new
    @dico.each_key do |key|
      token = %{"#{key}" => %{#{@dico[key]}}, \n\n}
      buffer.puts(token)
    end
    method_litteral = "
    def get_archive() 
      return Hash {
        #{buffer.to_s}
      }
    end"
    File.write(@arc, method_litteral)
  end # def make_archive
end # class

# class BakerStreetServer
class BakerStreetServer
    def BakerStreetServer.serve(host : String, port : Int32, debug : Bool)
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
        if debug
            puts "accessed : #{context.request.path}"
        end
        end

        # Running server
        if debug
        puts "Listening on http://#{host}:#{port}"
        end
        server.bind_tcp host, port
        server.listen
    end # def
end # class


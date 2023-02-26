require "path"
require "dir"

# TODO replace \n by a portable (OS dependent) newline symbol
# TODO Test on Windows.

class Baker
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

require "path"
require "dir"

# TODO replace \n by a portable (OS dependent) newline symbol
# TODO Test on Windows.

class Baker

  def initialize(root : String)
    @root = root
    @root_path = Path.new(@root)
    @dico      = Hash(String, String).new
    @arc       = "archive.cr"  
  end
  
  def to_path(file)
    return @root_path.join(file).to_s
  end
  
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
  
  def make_archive()
    walk_files_and_directories(@root)
    File.open(@arc, "w") do |file|
      file.print("def get_archive()
        \n\treturn Hash {\n\n")
    end
    File.open(@arc, "a") do |file|
      @dico.each_key do |key|
        token = %{"#{key}" => %{#{@dico[key]}}, \n}
        file.print(token)
        file.print("\n")
      end
    end
    File.open(@arc, "a") do |file|
      file.print("}")
    end
    File.open(@arc, "a") do |file|
      file.print("\n\nend")
    end
  end # def

end # class

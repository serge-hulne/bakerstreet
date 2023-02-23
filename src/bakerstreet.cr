require "path"
require "dir"

# TODO replace \n by a portable (OS dependent) newline symbol
# TODO Test on Windows.

module Baker
  
  VERSION = "0.1.0"
  extend self

  Root      = "public"
  Root_path = Path.new(Root)
  Dico      = Hash(String, String).new
  Arc       = "archive.cr"
  
  def to_path(file)
    return Root_path.join(file).to_s
  end
  
  def walk_files_and_directories(directory : String)
    Dir.each_child(directory) do |entry|
      path = File.join(directory, entry)
      if File.directory?(path)
        walk_files_and_directories(path)
      else
        content = File.read(path)
        Dico[path.to_s] = content
      end
    end
  end
  
  def make_archive()
    
    walk_files_and_directories(Root)
    
    File.open(Arc, "w") do |file|
      file.print("def get_archive()
        \n\treturn Hash {\n\n")
    end
    
    File.open(Arc, "a") do |file|
      Dico.each_key do |key|
        token = %{"#{key}" => %{#{Dico[key]}}, \n}
        file.print(token)
        file.print("\n")
      end
    end
    
    File.open(Arc, "a") do |file|
      file.print("}")
    end
    
    File.open(Arc, "a") do |file|
      file.print("\n\nend")
    end
  end

end

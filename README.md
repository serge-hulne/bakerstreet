# bakerstreet

- Simple virtual file system for embedding text files resources along with servers written in Crystal lang.
- In particular, supports : html, css, js and svg files.
- Does not support image files or binary files : jpeg, png, etc.
- For use in apps develpped using Crystal lang and WebView.
- The aim is portability of Crystal / Webview app between Linux, Mac and Windows 11.

***Alpha version***

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     bakerstreet:
       github: serge-hulne/bakerstreet
   ```

2. Run `shards install`

## Usage

- The code for the examples is installed in the "lib" directory of your current project.
- In order to try the examples hereunder, you can copy the "public" directory from "./libs" to the root of your current project (along "./src")


```crystal
require "bakerstreet"
```
See test_* files in ./src


## Example 1 of use : Creating an embedded archive
```
require "bakerstreet"

bk = Baker.new("public")
bk.make_archive()
```

## Example 2 of use : Using the embedded archive from example 1
```
require "../archive.cr"
require "bakerstreet"

bk = Baker.new("public")
arc = get_archive()

content = arc[bk.to_path("index.html")]
puts "file = #{content}"

```
## Example 3 of use : Using the embedded archive from example 1 in a server

```
require "http/server"
require "./bakerstreet"
require "../archive.cr"

HOST = "127.0.0.1"
PORT = 8080
DEBUG = true

# Server using URL to archive path mapping
bk = Baker.new("myapp/dist")
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
```



TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/bakerstreet/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [serge](https://github.com/your-github-user) - creator and maintainer

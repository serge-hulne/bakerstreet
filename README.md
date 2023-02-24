# bakerstreet

- Simple virtual file system for embedding text files resources along with servers written in Crystal lang.
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

```crystal
require "bakerstreet"
```
See test_* files in ./src

## Example of use

```
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

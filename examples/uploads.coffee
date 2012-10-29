{createServer} = require "http"
{createWriteStream} = require "fs"
Dimensions = require ".."

server = createServer (req, res) ->
  token = Date.now()
  req.pipe createWriteStream("uploads/#{token}")
  req.on "end", ->
    res.writeHead 201, {'Content-Type': 'application/json'}
    res.end JSON.stringify {token}
    
  

server.listen(3010)
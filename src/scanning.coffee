module.exports = 
  advance: (length) ->
    @position += length
    @throwScanError() if @position > @data.length


  readData: (size) ->
    data = @data[@position...(@position + size)]
    @advance(size)
    data


  readChar: ->
    @readData(1)[0]


  readShort: ->
    endianess = if @big then "BE" else "LE"
    @readData(2)["readUInt16#{endianess}"](0)


  readLong: ->
    endianess = if @big then "BE" else "LE"
    @readData(4)["readUInt32#{endianess}"](0)


  throwScanError: ->
    throw new Error "Dimensions scan error"

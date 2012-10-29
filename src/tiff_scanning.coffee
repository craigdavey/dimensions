module.exports =
  scanHeader: ->
    @scan_endianness()
    if @scan_tag_mark()
      @scan_and_skip_to_offset()

  scan_endianness: ->
    [one, two] = [@readChar(), @readChar()]
    @big = if one is two is 0x4D then yes else no

  scan_tag_mark: ->
    @readShort() is 0x002A

  scan_and_skip_to_offset: ->
    offset = @readLong()
    @skipTo(offset)

  scan_ifd: (callback) ->
    offset = @position
    entry_count = @readShort()

    for i in [0...entry_count]
      @skipTo(offset + 2 + (12 * i))
      tag = @readShort()
      callback tag

  readIntegerValue: ->
    type = @readShort()
    @advance(4)

    if type is 3
      @readShort()
    else if type is 4
      @readLong()
    else
      @throwScanError()

  skipTo: (position) ->
    @position = position
    @throwScanError() if @position > @data.length

# **[Dimensions](https://github.com/craigdavey/dimensions)** is a [Node](https://nodejs.org/) module to read width, height and rotation angle from GIF, PNG, JPEG and TIFF images.
# It is written in [Coffeescript](http://coffeescript.org/),
# it has [zero dependencies](https://github.com/craigdavey/dimensions/blob/master/package.json)
# and it is in the [Public Domain](https://unlicense.org/).
#
# This module was derived from [Sam Stephenson’s Dimensions Gem](https://github.com/sstephenson/dimensions)
# for the [Ruby](https://ruby-lang.org/) programming language.

Stream               = require "stream"
FormatIdentification = require "./format_identification"
JPEGScanner          = require "./jpeg_scanner"
TIFFScanner          = require "./tiff_scanner"

# Install the module with `npm install craigdavey/dimensions#0.0.1` and then require it in your program:
#
#     Dimensions = require "dimensions"
#
# The `Dimensions` constructor accepts a `Buffer` or a `Stream`.
# If you pass a `Buffer` the image dimensions will be processed immediately:
#
#     fs.readFile "nyc.jpg", (error, buffer) ->
#       dimensions = new Dimensions buffer
#       dimensions.height # Number of pixels.
#       dimensions.width  # Number of pixels.
#       dimensions.angle  # Rotation angle in degrees.
#
# Listen for the `"ready"` event when you pass or pipe a stream to an instance of `Dimensions`:
#
#     stream = fs.createReadStream "nyc.jpg"
#     dimensions = stream.pipe new Dimensions
#     dimensions.on "ready", ->
#       dimensions.height # Number of pixels.
#       dimensions.width  # Number of pixels.
#       dimensions.angle  # Rotation angle in degrees.
#
class Dimensions extends Stream
  module.exports = this

  SUPPORTED_TYPES = ["image/jpeg", "image/png", "image/gif", "image/tiff"]

  @canMeasure: (type) -> type in SUPPORTED_TYPES

  constructor: (bufferOrStream) ->
    if Buffer.isBuffer bufferOrStream
      @buffer = bufferOrStream
      @process()
    else
      @buffer = new Buffer 0
      @writable = true

      if bufferOrStream
        @stream = bufferOrStream
        @stream.on "data", @write
        @stream.on "end", @end

  # Identify the image format of the buffered data and then try to extract the image dimensions.
  process: ->
    @format ?= @identifyFormatOf @buffer
    @["extractDimensionsFor#{@format}"]() if @format
    @done() unless @writable

  # Include [image format identification](format_identification.html) methods.
  @prototype[name] = func for name, func of FormatIdentification

  # The `width` and `height` of a GIF is stored in a pair of unsigned 16 bit
  # integers with little endian formating at position `6` and `8`.
  extractDimensionsForGIF: ->
    if @buffer.length >= 10
      @width  = @buffer.readUInt16LE(6)
      @height = @buffer.readUInt16LE(8)
      @done()

  # The `width` and `height` of a PNG is stored in a pair of unsigned 32 bit
  # integers with little endian formating at position `16` and `20`.
  extractDimensionsForPNG: ->
    if @buffer.length >= 24
      @width  = @buffer.readUInt32BE(16)
      @height = @buffer.readUInt32BE(20)
      @done()

  # Delegates extraction to a [JPEGScanner](jpeg_scanner.html).
  extractDimensionsForJPEG: ->
    scanner = new JPEGScanner
    if scanner.scan @buffer
      @width  = scanner.width
      @height = scanner.height
      @angle  = scanner.angle
      @done()

  # Delegates extraction to a [TIFFScanner](tiff_scanner.html).
  extractDimensionsForTIFF: ->
    scanner = new TIFFScanner
    if scanner.scan @buffer
      @width  = scanner.width
      @height = scanner.height
      @done()

  # Called when the image dimensions have been successfully extracted or the buffer has been exhausted.
  # Deletes innessential members and emits a `"ready"` event with an object that contains `width`, `height` and `angle` dimensions.
  done: ->
    if @stream
      @stream.removeListener("data", @write)
      @stream.removeListener("end", @end)
      delete @stream

    delete @end
    delete @write
    delete @buffer
    delete @format

    if @writable
      delete @writable
      @emit "ready", @toJSON()


  # Returns an object with `width`, `height` and `angle` members that is suitable for serialization.
  toJSON: ->
    members = new Object
    members[name] = value for own name, value of this when name[0] isnt "_"
    return members

  # Record and process incoming `data` from a stream.
  # `write` always returns `true` because it has no need to apply back pressure on the read stream.
  # If the instance isn’t writable `write` is a noop.
  write: (data) =>
    if @writable
      @buffer = Buffer.concat [@buffer, data]
      @process()
    return true

  # Possibly write the last chunk of `data` and mark this as done.
  end: (data) =>
    @write data if data?
    @done()

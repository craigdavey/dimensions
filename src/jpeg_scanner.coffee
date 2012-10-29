# A `JPEGScanner` instance can read the `width`, `height` and `angle` dimensions from a JPEG image buffer.
# Usually the entire JPEG file doesn’t need to be loaded into the buffer to read the dimensions.
#
# JPEG images are formated in a series of frames and each frame is identified by a marker value.

# Frames come is all shapes and sizes but this scanner is only concerned with frame Zero and APP1 frames.

Scanning    = require "./scanning"
ExifScanner = require "./exif_scanner"

class JPEGScanner
  module.exports = this

  constructor: ->
    @angle = 0

  # Include methods from the [Scanning](scanning.coffee) module.
  @prototype[name] = func for name, func of Scanning

  # Start of image.
  SOI_MARKER = [0xFF, 0xD8]

  # Start of frame zero, source of `width` and `height`.
  SOF0_MARKER = 0xC0 

  # Potentially EXIF data, source of rotation `angle`.
  APP1_MARKER = 0xE1 

  # Start of scan marker – entropy-coded data follows.
  SOS_MARKER = 0xDA 

  # End of image.
  EOI_MARKER = 0xD9 

  # Scan the `buffer` for JPEG image dimensions. 
  scan: (buffer) ->
    @data = buffer
    @position = 0
    
    if @data.length > SOI_MARKER.length
      # Advance the position past the "Start of Image" marker.
      @advance SOI_MARKER.length

      # Steps through the image `buffer` one frame at a time.
      # Frame Zero and APP1 frames are scanned to extract dimensions while all the other frames are skipped.
      while marker = @readNextFrameMarker()
        switch marker
          when SOF0_MARKER then @scanZeroFrame()
          when APP1_MARKER then @scanApp1Frame()
          when EOI_MARKER, SOS_MARKER then break
          else @skipFrame()
    
    # Returns `true` if `width`, `height` and `angle` dimenisions were extracted. 
    # Returns `false` otherwise.
    @width? and @height? and @angle?

  # Advance through the buffer to the beginning of the next frame.
  # Returns a byte that identifies the frame or `undefined` if there are no more frames.
  readNextFrameMarker: ->
    if @position < @data.length
      c = @readChar() until c is 0xFF
      c = @readChar() while c is 0xFF
      return c

  # Read `width` and `height` dimensions from the Zero frame.
  scanZeroFrame: ->
    length = @data.readUInt16BE(@position)
    
    if (@position + length) > @data.length
      @position = @data.length
    else
      @advance(2)
      @advance(1)
      height = @data.readUInt16BE(@position)
      @advance(2)
      width  = @data.readUInt16BE(@position)
      @advance(2)
      size = @data[@position]

      if length is (size * 3) + 8
        [@width, @height] = [width, height]

  # Look for Exif data in the frame. 
  # If Exif data is present, read it to determine the rotation `angle` of the image.
  # Delegates to an [Exif scanner](exif_scanner.coffee) to read the Exif data.
  scanApp1Frame: ->
    if frame = @readFrame()
      if frame[2..5].toString() is "Exif" and frame[6] is frame[7] is 0
        scanner = new ExifScanner 
        scanner.scan frame[8..-1]
        switch scanner.orientation
          when "left_top", "right_top"       then @angle = 90
          when "bottom_right"                then @angle = 180
          when "right_bottom", "left_bottom" then @angle = 270

  # Read the current frame data and return it as a buffer.
  readFrame: ->
    length = @data.readUInt16BE(@position)
    if (@position + length) > @data.length
      @position = @data.length
      return false
    else
      @readData length
      
  # Read the length of the current frame and skip past it.
  skipFrame: ->
    length = @data.readUInt16BE(@position)
    if (@position + length) > @data.length
      @position = @data.length
    else
      @advance length

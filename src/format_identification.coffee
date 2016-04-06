GIF_HEADER    = new Buffer [0x47, 0x49, 0x46, 0x38]
PNG_HEADER    = new Buffer [0x89, 0x50, 0x4E, 0x47]
JPEG_HEADER   = new Buffer [0xFF, 0xD8, 0xFF]
TIFF_HEADER_I = new Buffer [0x49, 0x49, 0x2A, 0x00]
TIFF_HEADER_M = new Buffer [0x4D, 0x4D, 0x00, 0x2A]

matchHeader = (header, bytes) ->
  bytes[0...header.length].toString("hex") is header.toString("hex")

module.exports =
  identifyFormatOf: (buffer) ->
    if buffer.length >= 4
      bytes = buffer[0...4]
      switch
        when matchHeader GIF_HEADER,    bytes then "GIF"
        when matchHeader PNG_HEADER,    bytes then "PNG"
        when matchHeader JPEG_HEADER,   bytes then "JPEG"
        when matchHeader TIFF_HEADER_I, bytes then "TIFF"
        when matchHeader TIFF_HEADER_M, bytes then "TIFF"

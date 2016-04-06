Scanning     = require "./scanning"
TIFFScanning = require "./tiff_scanning"

module.exports = class TIFFScanner
  @prototype[name] = func for name, func of Scanning
  @prototype[name] = func for name, func of TIFFScanning
  
  WIDTH_TAG  = 0x100
  HEIGHT_TAG = 0x101

  scan: (data) ->
    @data = data
    @position = 0

    @scanHeader()

    @scan_ifd (tag) =>
      switch tag
        when WIDTH_TAG  then @width  = @readIntegerValue()
        when HEIGHT_TAG then @height = @readIntegerValue()

    @width and @height

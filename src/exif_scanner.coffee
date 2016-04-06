Scanning     = require "./scanning"
TIFFScanning = require "./tiff_scanning"

module.exports = class ExifScanner
  @prototype[name] = func for name, func of Scanning
  @prototype[name] = func for name, func of TIFFScanning
  
  ORIENTATION_TAG = 0x0112

  ORIENTATIONS = [
    "top_left"
    "top_right"
    "bottom_right"
    "bottom_left"
    "left_top"
    "right_top"
    "right_bottom"
    "left_bottom"
  ]


  scan: (data) ->
    @data = data
    @position = 0    
    @scanHeader()
    @scan_ifd (tag) =>
      if tag is ORIENTATION_TAG
        value = @readIntegerValue()
        if @validOrientation(value)
          @orientation = ORIENTATIONS[value - 1]

    @orientation


  validOrientation: (value) ->
    value in [1..ORIENTATIONS.length]

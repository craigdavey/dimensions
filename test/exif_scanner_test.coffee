{buffer}    = require "./test_helper"
ExifScanner = require "../src/exif_scanner"

module.exports =
  "scanning Exif with top left orientation": (test) ->
    scanner = new ExifScanner 
    test.ok scanner.scan buffer("top_left.exif")
    test.strictEqual "top_left", scanner.orientation
    test.done()

  "scanning Exif with right top orientation": (test) ->
    scanner = new ExifScanner 
    test.ok scanner.scan buffer("right_top.exif")
    test.strictEqual "right_top", scanner.orientation
    test.done()

  "scanning Exif with invalid orientation": (test) ->
    scanner = new ExifScanner
    test.strictEqual undefined, scanner.scan buffer("invalid.exif")
    test.strictEqual undefined, scanner.orientation
    test.done()

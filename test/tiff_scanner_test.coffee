{buffer}    = require "./test_helper"
TIFFScanner = require "../src/tiff_scanner"

module.exports =
  "scanning TIFF with short values": (test) ->
    scanner = new TIFFScanner 
    test.ok scanner.scan buffer("short.tif")
    test.equality 50, scanner.width
    test.equality 20, scanner.height
    test.done()

  "scanning TIFF with long values": (test) ->
    scanner = new TIFFScanner
    test.assert scanner.scan buffer("long.tif")
    test.equality 67000, scanner.width
    test.equality 1, scanner.height
    test.done()

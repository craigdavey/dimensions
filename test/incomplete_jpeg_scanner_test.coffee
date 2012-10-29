{buffer}    = require "./test_helper"
JPEGScanner = require "../src/jpeg_scanner"

module.exports =
  "dimensions are undefined for jpg without bytes": (test) ->
    scanner = new JPEGScanner
    test.equality false, scanner.scan(buffer("zero_bytes"))
    test.equality undefined, scanner.width
    test.equality undefined, scanner.height
    test.equality 0, scanner.angle
    test.done()

  "dimensions are undefined for jpg with incomplete APP1 frame": (test) ->
    scanner = new JPEGScanner
    test.equality false, scanner.scan(buffer("incomplete_app_1_frame.jpg"))
    test.equality undefined, scanner.width
    test.equality undefined, scanner.height
    test.equality 0, scanner.angle
    test.done()

  "dimensions are undefined for jpg with incomplete Zero frame": (test) ->
    scanner = new JPEGScanner
    test.equality false, scanner.scan(buffer("incomplete_zero_frame.jpg"))
    test.equality undefined, scanner.width
    test.equality undefined, scanner.height
    test.equality 0, scanner.angle
    test.done()

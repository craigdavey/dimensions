{buffer}    = require "./test_helper"
JPEGScanner = require "../src/jpeg_scanner"

module.exports = 
  "scanning basic JPEG": (test) ->
    scanner = new JPEGScanner
    test.assert scanner.scan buffer("upload_bird.jpg")
    test.equality 300, scanner.width
    test.equality 225, scanner.height
    test.equality   0, scanner.angle
    test.done()
  
  "scanning rotated JPEG": (test) ->
    scanner = new JPEGScanner
    test.assert scanner.scan buffer("rotated.jpg")
    test.equality 2592, scanner.width
    test.equality 1936, scanner.height
    test.equality   90, scanner.angle
    test.done()
  
  "scanning problematic JPEG": (test) ->
    scanner = new JPEGScanner
    test.assert scanner.scan buffer("image001.jpg")
    test.equality 468, scanner.width
    test.equality  60, scanner.height
    test.equality   0, scanner.angle
    test.done()
  

  "scanning problematic JPEG 2": (test) ->
    scanner = new JPEGScanner
    test.assert scanner.scan buffer("20120920-205559-170.jpg")
    test.equality 2000, scanner.width
    test.equality 1500, scanner.height
    test.equality    0, scanner.angle
    test.done()
  

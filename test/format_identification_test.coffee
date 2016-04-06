{buffer} = require "./test_helper"
Dimensions  = require ".."

assertFormat = (test, format, filename) ->
  test.equality format, (new Dimensions).identifyFormatOf(buffer(filename))

module.exports =
  "identifying GIF files": (test) ->
    assertFormat test, "GIF", "ad.gif"
    assertFormat test, "GIF", "basecamp.gif"
    test.done()

  "identifying PNG files": (test) ->
    assertFormat test, "PNG", "close.png"
    assertFormat test, "PNG", "screenshot.png"
    test.done()

  "identifying JPEG files": (test) ->
    assertFormat test, "JPEG", "upload_bird.jpg"
    assertFormat test, "JPEG", "rotated.jpg"
    test.done()

  "identifying TIFF files": (test) ->
    assertFormat test, "TIFF", "long.tif"
    assertFormat test, "TIFF", "short.tif"
    test.done()

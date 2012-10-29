{buffer}  = require "./test_helper"
Dimensions = require ".."

module.exports =
  "dimensions of animated GIF": (test) ->
    dimensions = new Dimensions buffer("ad.gif")
    test.symmetry dimensions, 
      width:  300
      height: 250
    test.done()
    
  "dimensions of static GIF": (test) ->
    dimensions = new Dimensions buffer("basecamp.gif")
    test.symmetry dimensions, 
      width:  153
      height: 36
    test.done()

  "dimensions of small PNG": (test) ->
    dimensions = new Dimensions buffer("close.png")
    test.symmetry dimensions, 
      height: 25
      width:  25
    test.done()
  
  "dimensions of big PNG": (test) ->
    dimensions = new Dimensions buffer("screenshot.png")
    test.symmetry dimensions, 
      height: 523
      width:  769
    test.done()
  
  "dimensions of basic JPEG": (test) ->
    dimensions = new Dimensions buffer("upload_bird.jpg")
    test.symmetry dimensions, 
      height: 225
      width:  300
      angle:  0
    test.done()

  "dimensions of rotated JPEG": (test) ->
    dimensions = new Dimensions buffer("rotated.jpg")
    test.symmetry dimensions, 
      width:  2592
      height: 1936
      angle:  90
    test.done()

  "dimensions of TIFF": (test) ->
    dimensions = new Dimensions buffer("short.tif")
    test.symmetry dimensions, 
      width:  50
      height: 20
    test.done()

  "dimensions of unsupported BMP": (test) ->
    dimensions = new Dimensions buffer("canadapost.bmp")
    test.symmetry dimensions, {}
    test.done()

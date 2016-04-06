{stream}  = require "./test_helper"
Dimensions = require ".."

module.exports =
  "dimensions of animated GIF": (test) ->
    dimensions = stream("ad.gif").pipe new Dimensions
    dimensions.on "ready", (dimensions) ->
      test.symmetry dimensions, 
        width:  300
        height: 250
      test.done()
    
  "dimensions of static GIF": (test) ->
    dimensions = stream("basecamp.gif").pipe new Dimensions
    dimensions.on "ready", (dimensions) ->
      test.symmetry dimensions, 
        width:  153
        height: 36
      test.done()

  "dimensions of small PNG": (test) ->
    dimensions = new Dimensions
    stream("close.png").pipe dimensions
    dimensions.on "ready", (dimensions) ->
      test.symmetry dimensions, 
        width:  25
        height: 25
      test.done()

  "dimensions of big PNG": (test) ->
    dimensions = new Dimensions
    stream("screenshot.png").pipe dimensions
    dimensions.on "ready", (dimensions) ->
      test.symmetry dimensions, 
        height: 523
        width:  769
      test.done()
  
  "dimensions of basic JPEG": (test) ->
    dimensions = new Dimensions
    stream("upload_bird.jpg").pipe dimensions
    dimensions.on "ready", (dimensions) ->
      test.symmetry dimensions, 
        height: 225
        width:  300
        angle:  0
      test.done()
  
  "dimensions of rotated JPEG": (test) ->
    dimensions = new Dimensions
    stream("rotated.jpg").pipe dimensions
    dimensions.on "ready", (dimensions) ->
      test.symmetry dimensions, 
        width:  2592
        height: 1936
        angle:  90
      test.done()

  "dimensions of TIFF": (test) ->
    dimensions = new Dimensions
    stream("short.tif").pipe dimensions
    dimensions.on "ready", (dimensions) ->
      test.symmetry dimensions, 
        width:  50
        height: 20
      test.done()

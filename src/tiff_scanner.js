// Generated by CoffeeScript 1.10.0
(function() {
  var Scanning, TIFFScanner, TIFFScanning;

  Scanning = require("./scanning");

  TIFFScanning = require("./tiff_scanning");

  module.exports = TIFFScanner = (function() {
    var HEIGHT_TAG, WIDTH_TAG, func, name;

    function TIFFScanner() {}

    for (name in Scanning) {
      func = Scanning[name];
      TIFFScanner.prototype[name] = func;
    }

    for (name in TIFFScanning) {
      func = TIFFScanning[name];
      TIFFScanner.prototype[name] = func;
    }

    WIDTH_TAG = 0x100;

    HEIGHT_TAG = 0x101;

    TIFFScanner.prototype.scan = function(data) {
      this.data = data;
      this.position = 0;
      this.scanHeader();
      this.scan_ifd((function(_this) {
        return function(tag) {
          switch (tag) {
            case WIDTH_TAG:
              return _this.width = _this.readIntegerValue();
            case HEIGHT_TAG:
              return _this.height = _this.readIntegerValue();
          }
        };
      })(this));
      return this.width && this.height;
    };

    return TIFFScanner;

  })();

}).call(this);
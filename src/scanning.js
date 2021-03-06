// Generated by CoffeeScript 1.10.0
(function() {
  module.exports = {
    advance: function(length) {
      this.position += length;
      if (this.position > this.data.length) {
        return this.throwScanError();
      }
    },
    readData: function(size) {
      var data;
      data = this.data.slice(this.position, this.position + size);
      this.advance(size);
      return data;
    },
    readChar: function() {
      return this.readData(1)[0];
    },
    readShort: function() {
      var endianess;
      endianess = this.big ? "BE" : "LE";
      return this.readData(2)["readUInt16" + endianess](0);
    },
    readLong: function() {
      var endianess;
      endianess = this.big ? "BE" : "LE";
      return this.readData(4)["readUInt32" + endianess](0);
    },
    throwScanError: function() {
      throw new Error("Dimensions scan error");
    }
  };

}).call(this);

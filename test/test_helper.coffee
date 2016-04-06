{assert} = require "nodeunit"

assert.assert = (a, message) -> assert.ok(a, message)
assert.equality = (a, b, message) -> assert.strictEqual(a, b, message)
assert.symmetry = (a, b, message) -> assert.deepEqual(a, b, message)

{createReadStream, readFileSync} = require "fs"

exports.buffer = (filename) -> readFileSync     "test/fixtures/#{filename}"
exports.stream = (filename) -> createReadStream "test/fixtures/#{filename}"

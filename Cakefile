{spawn, exec} = require 'child_process'
{print} = require 'util'

task "test", "Run the test suite", (options) ->
  tests = process.env["TEST"] or "test/*_test.coffee"
  child = exec "NODE_ENV=test ./node_modules/.bin/nodeunit #{tests}"
  child.stdout.on "data", print
  child.stderr.on "data", print
  child.on "exit", process.exit

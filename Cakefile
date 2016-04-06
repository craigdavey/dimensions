{spawn, exec} = require 'child_process'

task "test", "Run the test suite", (options) ->
  tests = process.env["TEST"] or "test/*_test.coffee"
  child = exec "NODE_ENV=test ./node_modules/.bin/nodeunit #{tests}"
  child.stdout.on "data", (text) -> console.info  text.trim()
  child.stderr.on "data", (text) -> console.error text.trim()
  child.on "exit", process.exit

task "docs", "Generate documentation", (options) ->
  child = exec "docco src/* test/*"
  child.stdout.on "data", (text) -> console.info  text.trim()
  child.stderr.on "data", (text) -> console.error text.trim()
  child.on "exit", process.exit

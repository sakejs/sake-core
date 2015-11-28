chai = require 'chai'
chai.should()
chai.use require 'chai-as-promised'

# convenient for testing
Object.defineProperty String.prototype, 'lines',
  get: -> @split '\n'

path = require 'path'
exec = require('executive').quiet

# path to shortcake
bin = path.join __dirname, '../bin/shortcake'
cwd = path.join __dirname, '../test'

# Helper to run shortcake in tests
run = (cmd, cb) ->
  exec "#{bin} #{cmd}", {cwd: cwd}

before -> global.run = run

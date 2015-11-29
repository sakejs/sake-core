chai = require 'chai'
chai.should()
chai.use require 'chai-as-promised'

# convenient for testing
Object.defineProperty String.prototype, 'lines',
  get: -> @split '\n'

path = require 'path'
exec = require('executive').quiet

# path to shortcake
cwd = __dirname
bin = path.join cwd, '/../bin/shortcake'

# Helper to run shortcake in tests
run = (cmd) ->
  p = exec "#{bin} #{cmd}", {cwd: cwd}
  p.then (res) ->
    res.stdout = res.stdout.trim()
    res.stderr = res.stdout.trim()
  p.catch (err) ->
    throw err

before -> global.run = run

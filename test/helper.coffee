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

execPromise = (cmd) ->
  new Promise (resolve, reject) ->
    exec "#{bin} #{cmd}", {cwd: cwd}, (err, stdout, stderr) ->
      return reject err if err?

      # strip trailing newline
      stdout = stdout.substring 0, stdout.length - 1

      resolve([stdout, stderr])

# Helper to run shortcake in tests
exports.run = (cmd, cb) ->
  return execPromise cmd unless cb?

  execPromise cmd
    .then (res) ->
      [stdout, stderr] = res
      cb null, stdout, stderr
    .catch (err) ->
      cb err, err.stdout, err.stderr

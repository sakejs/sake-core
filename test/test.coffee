path = require 'path'
exec = require('executive').quiet
{assert} = require 'chai'

# path to shortcake
bin = path.join __dirname, '../bin/shortcake'

# convenient for testing
Object.defineProperty String.prototype, 'lines',
  get: -> @split '\n'

# wrapper to run shortcake against the Cakefile in test/
run = (cmd, cb) ->
  exec "#{bin} #{cmd}", {cwd: __dirname}, (err, stdout, stderr) ->
    console.log stderr if stderr != ''
    cb err, stdout, stderr

describe 'invoke', ->
  it 'should show usage like normal cake', (done) ->
    run '', (err, stdout, stderr) ->
      return done err if err

      assert.equal 'Cakefile defines the following tasks:', stdout.lines[0]
      done()

  it 'should execute callback when tasks finishes', (done) ->
    run 'invoke:callback', (err, stdout, stderr) ->
      return done err if err

      assert.deepEqual ['async1', 'async2', 'async3', ''], stdout.lines
      done()

  it 'should execute multiple tasks in serial if called with an array', (done) ->
    run 'invoke:serial', (err, stdout, stderr) ->
      return done err if err

      assert.deepEqual ['async1', 'async2', 'async3', ''], stdout.lines
      done()

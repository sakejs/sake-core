path = require 'path'
exec = require('executive').quiet
{assert} = require 'chai'

# path to shortcake
bin = path.join __dirname, '../bin/shortcake'
cwd = path.join __dirname, '../test'

# convenient for testing
Object.defineProperty String.prototype, 'lines',
  get: -> @split '\n'

# wrapper to run shortcake against the Cakefile in test/
run = (cmd, cb) ->
  exec "#{bin} #{cmd}", {cwd: cwd}, (err, stdout, stderr) ->
    console.log stderr if stderr != ''
    throw err if err?

    # strip tailing newline
    stdout = stdout.substring 0, stdout.length - 1

    cb err, stdout, stderr

describe 'shortcake', ->
  describe 'bin/shortcake', ->
    it 'should show usage like normal cake', (done) ->
      run '', (err, stdout, stderr) ->
        assert.equal stdout.lines[0], 'Cakefile defines the following tasks:'
        done()

  describe '#task', ->
    it 'should accept action expecting options', (done) ->
      run 'task:options', (err, stdout, stderr) ->
        assert.equal stdout, "{ arguments: [ 'task:options' ] }"
        done()

    it 'should accept action expecting only a callback', (done) ->
      run 'task:done', (err, stdout, stderr) ->
        assert.equal stdout, '[Function]'
        done()

    it 'should accept action expecting options, callback', (done) ->
      run 'task:options,done', (err, stdout, stderr) ->
        assert.equal stdout, "{ arguments: [ 'task:options,done' ] }"
        done()

  describe '#invoke', ->
    it 'should fail to run non-existent task', (done) ->
      exec "#{bin} task:doesntexist", {cwd: cwd}, (err, stdout, stderr) ->
        assert.instanceOf err, Error
        done()

    it 'should execute callback when tasks finishes', (done) ->
      run 'invoke', (err, stdout, stderr) ->
        assert.deepEqual stdout.lines, ['delay:20'
                                        'delay:10'
                                        'delay:0'
                                        'invoke']
        done()

  describe '#invoke.serial', ->
    it 'should invoke multiple tasks in serial', (done) ->
      run 'invoke.serial', (err, stdout, stderr) ->
        assert.deepEqual stdout.lines, ['delay:20'
                                        'delay:10'
                                        'delay:0'
                                        'invoke.serial']

        done()

  describe '#invoke.parallel', ->
    it 'should invoke multiple tasks in parallel', (done) ->
      run 'invoke.parallel', (err, stdout, stderr) ->
        assert.deepEqual stdout.lines, ['delay:0'
                                        'delay:10'
                                        'delay:20'
                                        'invoke.parallel']
        done()

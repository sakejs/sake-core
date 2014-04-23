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
    cb err, stdout, stderr

describe 'shortcake', ->
  it 'should show usage like normal cake', (done) ->
    run '', (err, stdout, stderr) ->
      return done err if err

      assert.equal stdout.lines[0], 'Cakefile defines the following tasks:'
      done()

  describe 'invoke', ->
    it 'should execute callback when tasks finishes', (done) ->
      run 'invoke', (err, stdout, stderr) ->
        return done err if err

        assert.deepEqual stdout.lines, ['delay:20'
                                        'delay:10'
                                        'delay:0'
                                        'invoke'
                                        '']
        done()

  describe 'invoke.serial', ->
    it 'should invoke multiple tasks in serial', (done) ->
      run 'invoke.serial', (err, stdout, stderr) ->
        return done err if err

        assert.deepEqual stdout.lines, ['delay:20'
                                        'delay:10'
                                        'delay:0'
                                        'invoke.serial'
                                        '']

        done()

  describe 'invoke.parallel', ->
    it 'should invoke multiple tasks in parallel', (done) ->
      run 'invoke.parallel', (err, stdout, stderr) ->
        return done err if err

        assert.deepEqual stdout.lines, ['delay:0'
                                        'delay:10'
                                        'delay:20'
                                        'invoke.parallel'
                                        '']
        done()

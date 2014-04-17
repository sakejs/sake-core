exec = require('executive').quiet
{assert} = require 'chai'

describe 'invoke', ->
  it 'should allow chains of async tasks to be run', (done) ->
    exec 'shortcake async1:async2', {cwd: __dirname}, (err, out) ->
      assert.deepEqual ['async1', 'async2', 'async1:async2', ''], out.split '\n'
      done err

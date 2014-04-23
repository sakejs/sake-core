exec = require('executive').quiet
{assert} = require 'chai'

describe 'invoke', ->
  it 'should execute callback when tasks finishes', (done) ->
    exec 'shortcake invoke:callback', {cwd: __dirname}, (err, out) ->
      assert.deepEqual ['async1', 'async2', 'async3', ''], out.split '\n'
      done err

  it 'should execute multiple tasks in serial if called with an array', (done) ->
    exec 'shortcake invoke:serial', {cwd: __dirname}, (err, out) ->
      assert.deepEqual ['async1', 'async2', 'async3', ''], out.split '\n'
      done err

exec = require 'executive'

describe 'invoke', ->
  it 'should allow chains of async tasks to be run', (done) ->
    exec 'shortcake', {cwd: __dirname}, done

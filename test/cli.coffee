{run} = require './helper'

describe 'bin/shortcake', ->
  it 'should show normal cake usage', ->
    [stdout, stderr] = yield run ''
    stdout.lines[0].should.equal 'Cakefile defines the following tasks:'

  it 'should shift tasks from beginning of arguments to end', ->
    [stdout, stderr] = yield run 'option -v'
    stdout.should.equal 'true'

  it 'should not shift options to end of arguments', ->
    [stdout, stderr] = yield run '-v option'
    stdout.should.equal 'true'

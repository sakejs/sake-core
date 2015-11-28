describe 'bin/shortcake', ->
  it 'should show normal cake usage', ->
    {stdout} = yield run ''
    stdout.lines[0].should.equal 'Cakefile defines the following tasks:'

  it 'should shift tasks from beginning of arguments to end', ->
    {stdout} = yield run 'option -v'
    stdout.should.equal 'true'

  it 'should not shift options to end of arguments', ->
    {stdout} = yield run '-v option'
    stdout.should.equal 'true'

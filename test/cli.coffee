describe 'bin/sake', ->
  it 'should show normal sake usage', ->
    {stdout} = yield run ''
    stdout.lines[0].should.equal 'Cakefile defines the following tasks:'

  it 'should shift tasks from beginning of arguments to end', ->
    {stdout} = yield run 'options -v'
    stdout.should.equal 'true'

  it 'should not shift options to end of arguments', ->
    {stdout} = yield run '-v options'
    stdout.should.equal 'true'

  it 'should fail to run non-existent task', ->
    {status} = yield run 'non-existent-task'
    status.should.eq 1


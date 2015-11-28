describe 'task', ->
  it 'should accept action expecting options', ->
    {stdout} = yield run 'task:options'
    stdout.should.equal "{ arguments: [ 'task:options' ] }"

  it 'should accept action expecting only a callback', ->
    {stdout} = yield run 'task:done'
    stdout.should.equal '[Function]'

  it 'should accept action expecting options, callback', ->
    {stdout} = yield run 'task:options,done'
    stdout.should.equal "{ arguments: [ 'task:options,done' ] }"

describe 'task', ->
  it 'should accept action expecting options', ->
    [stdout, stderr] = yield run 'task:options'
    stdout.should.equal "{ arguments: [ 'task:options' ] }"

  it 'should accept action expecting only a callback', ->
    [stdout, stderr] = yield run 'task:done'
    stdout.should.equal '[Function]'

  it 'should accept action expecting options, callback', ->
    [stdout, stderr] = yield run 'task:options,done'
    stdout.should.equal "{ arguments: [ 'task:options,done' ] }"

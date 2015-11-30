describe 'invoke', ->
  it 'should invoke tasks in serial', ->
    {stdout} = yield run 'serial'
    stdout.should.eq '''
      delay:20
      delay:10
      delay:0
      serial
      '''

  it 'should execute nested invoke calls', ->
    {stdout} = yield run 'nested'
    stdout.should.eq '''
      delay:20
      delay:10
      delay:0
      nested
      '''

describe 'invoke.parallel', ->
  it 'should invoke tasks in parallel', ->
    {stdout} = yield run 'parallel'
    stdout.should.eq '''
      delay:0
      delay:10
      delay:20
      parallel
      '''

describe 'task', ->
  it 'should accept action expecting options', ->
    {stdout} = yield run 'options-empty'
    stdout.should.equal "{ arguments: [ 'options-empty' ] }"

  it 'should accept action expecting only a callback', ->
    {stdout} = yield run 'async'
    stdout.should.equal '[Function]'

  it 'should accept action expecting options, callback', ->
    {stdout} = yield run 'async-options'
    stdout.should.equal "{ arguments: [ 'async-options' ] }"

  it 'should accept task without description', ->
    {stdout} = yield run 'no-description'
    stdout.should.equal 'no-description'

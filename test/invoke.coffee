describe 'invoke', ->
  it 'should fail to run non-existent task', ->
    yield (run 'non-existent-task')
            .should.be.rejectedWith /shortcake exited with code 1/

  it 'should execute callback when tasks finishes', ->
    [stdout] = yield run 'invoke'
    stdout.should.eq '''
      delay:20
      delay:10
      delay:0
      invoke
      '''

describe 'invoke.serial', ->
  it 'should invoke multiple tasks in serial', ->
    [stdout] = yield run 'invoke.serial'
    stdout.should.eq '''
      delay:20
      delay:10
      delay:0
      invoke.serial
      '''

describe 'invoke.parallel', ->
  it 'should invoke multiple tasks in parallel', ->
    [stdout] = yield run 'invoke.parallel'
    stdout.should.eq '''
      delay:0
      delay:10
      delay:20
      invoke.parallel
      '''

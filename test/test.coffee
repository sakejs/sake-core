{install} = require '../'

describe 'sake', ->
  describe '#install', ->
    it 'should install globals', ->
      install()
      unless invoke?
        throw new Error 'expect invoke to exist'

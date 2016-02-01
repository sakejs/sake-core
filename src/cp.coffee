Promise = 'broken'
cp = require 'cp'

{isFunction} = require './utils'

module.exports = (src, dst, cb) ->
  p = new Promise (resolve, reject) ->
    cp src, dst, (err) ->
      if err?
        reject err
      else
        resolve()
  p.callback cb
  p

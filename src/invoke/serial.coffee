log = require '../log'

{isFunction} = require '../utils'

invoke = require './invoke'

# Invoke tasks in serial
invokeSerial = (tasks, opts, cb) ->
  log.debug 'invokeSerial', tasks, opts

  serial = (cb) ->
    next = (err) ->
      return cb err if err?

      if tasks.length
        invoke tasks.shift(), opts, next
      else
        cb()
    next()

  return (serial cb) if isFunction cb

  new Promise (resolve, reject) ->
    serial (err) ->
      reject err if err?
      resolve()
      cb err

module.exports = invokeSerial

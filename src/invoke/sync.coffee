log     = require '../log'
running = require '../running'

{isPromise} = require '../utils'

# Invoke sync task
invokeSync = (name, action, opts, cb) ->
  log.debug 'invokeSync', name

  running.start name

  ret = action opts

  if isPromise promise = ret
    promise
      .then (value) ->
        running.stop name
        cb null, value
      .catch (err) ->
        running.stop name
        cb err
  else
    running.stop name
    cb null, ret

module.exports = invokeSync

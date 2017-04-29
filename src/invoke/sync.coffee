import isPromise from 'es-is/promise'

import log     from '../log'
import running from '../running'


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

export default invokeSync

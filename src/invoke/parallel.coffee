import invoke       from './invoke'
import log          from '../log'
import {isFunction} from '../utils'

# Invoke tasks in serial
invokeParallel = (tasks, opts, cb) ->
  log.debug 'invokeParallel', tasks, opts

  parallel = (cb) ->
    done = 0
    for task in tasks
      invoke task, opts, ->
        if ++done == tasks.length
          cb()

  return (parallel cb) if isFunction cb

  new Promise (resolve, reject) ->
    parallel (err) ->
      reject err if err?
      resolve()
      cb err if isFunction cb

export default invokeParallel

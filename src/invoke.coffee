isFunction  = require 'is-function'
isGenerator = require 'is-generator-fn'
running     = require './running'

module.exports = (tasks = {}, cakeInvoke = global.task) ->
  # Our `invoke` takes a callback which should be called when a task has
  # completed.

  cachedOptions = null

  invoke = (name, options, cb) ->
    # Called with a callback and no options
    if isFunction options
      [cb, options] = [options, {}]

    # Ensure callback and options exist
    cb      = (->) unless cb?
    options = {}   unless options?

    # Call original invoke (to throw missing task error, mostly).
    cakeInvoke name

    # Get task object
    task = tasks[name]

    # Cache options
    cachedOptions ?= task.options

    # Extend caller provided options with cachedOptions
    for k,v of cachedOptions
      options[k] ?= v

    # Pull out action, deps
    {action, deps} = task

    # Process deps in order
    invokeSerial deps, ->
      running.start name

      if isGenerator action
        gen = action options
        value = null
        until (ret = gen.next()).done
          {value} = ret
        running.stop name
        cb value
        return

      # Two arguments, action expects callback
      if action.length == 2
        action options, ->
          running.stop name
          cb.apply null, arguments
        return

      # Single argument, detected callback
      if /^function \((callback|cb|done|next)\)/.test action.toString()
        action ->
          running.stop name
          cb.apply null, arguments
        return

      # 0 or 1 argument action, no callback detected
      ret = action options
      running.stop name
      cb ret

  # Invoke tasks in serial
  invokeSerial = (tasks, cb) ->
    do (next = ->
      if tasks.length
        invoke tasks.shift(), next
      else
        cb())

  # Invoke tasks in serial
  invokeParallel = (tasks, cb = ->) ->
    done = 0
    for task in tasks
      invoke task, ->
        if ++done == tasks.length
          cb()

  wrapper = (task, cb = ->) ->
    if Array.isArray task
      invokeSerial task, cb
    else
      invoke task, cb

  wrapper.serial   = invokeSerial
  wrapper.parallel = invokeParallel

  wrapper

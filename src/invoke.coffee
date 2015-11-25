isFunction  = require 'is-function'
isGenerator = require 'is-generator-fn'
isPromise   = require 'is-promise'
running     = require './running'

invokeGenerator = (name, action, options, cb) ->
  running.start name

  gen = action options

  last = null
  prev = null

  done = (err) ->
    running.stop name
    cb err, (last ? prev)

  next = (value) ->
    res = gen.next value

    prev = last
    last = res.value

    if isPromise promise = res.value
      promise
        .then (value) ->
          next value
        .catch (err) ->
          throw err
    else if not res.done
      next res.value
    else
      done()

  next()

invokeAsync = (name, action, options, cb) ->
  running.start name

  done = ->
    running.stop name
    cb.apply null, arguments

  if options?
    action options, done
  else
    action done

invokeSync = (name, action, options, cb) ->
  running.start name

  ret = action options

  running.stop name
  cb ret


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
    for k, v of cachedOptions
      options[k] ?= v

    # Pull out action, deps
    {action, deps} = task

    # Process deps in order
    invokeSerial deps, ->
      running.start name

      # Is a generator task
      if isGenerator action
        return invokeGenerator name, action, options, cb

      # Two arguments, action expects callback
      if action.length == 2
        return invokeAsync name, action, options, cb

      # Single argument, detected callback
      if /^function \((callback|cb|done|next)\)/.test action.toString()
        return invokeAsync name, action, null, cb

      # 0 or 1 argument action, no callback detected
      invokeSync name, action, options, cb

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

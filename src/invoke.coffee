isFunction = require 'is-function'
running    = require './running'

module.exports = (tasks = {}, cakeInvoke = global.task) ->
  # Our `invoke` takes a callback which should be called when a task has
  # completed.

  invoke = (name, options, cb) ->
    # Call original invoke to set options on task object.
    cakeInvoke name

    unless cb?
      if isFunction options
        [cb, options] = [options, {}]

    unless options?
      options = {}

    # Override cake processed opts if provided by caller
    for k,v of options
      tasks[name].options[k] = v

    # Pull out action, deps, options
    {action, deps, options} = tasks[name]

    # Process deps in order
    invokeSerial deps, ->
      running.start name

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
      res = action options
      running.stop name
      cb res

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

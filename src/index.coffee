exec       = require __dirname + '/../node_modules/executive'
running    = require './running'

(require 'coffee-script/register')
(require 'source-map-support').install()

# save references to original invoke, task
cakeInvoke = global.invoke
cakeTask   = global.task

tasks = {}

# Our Task can optionally specify dependencies or a callback if it's
# asynchronous
task = (name, description, deps, action) ->
  # No dependencies specified, ex: `task 'name', 'description', ->`
  if typeof deps is 'function'
    [action, deps] = [deps, []]

  # Missing task function (body), ex: `task 'name', 'description', ['1','2','3']`
  unless typeof action is 'function'
    action = ->

  # store reference for ourselves
  tasks[name] = {name, description, deps, action}

  # make sure original plumbing still works, inject our shim task
  cakeTask name, description, (options) ->
    # we capture result of options for our own invoke step
    tasks[name].options = options

# Our invoke takes a callback which should be called when a task has completed.
invoke = (name, cb) ->
  # Call original invoke to set options for our task.
  cakeInvoke name

  {action, deps, options} = tasks[name]

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

invokeWrapper = (task, cb = ->) ->
  if Array.isArray task
    invokeSerial task, cb
  else
    invoke task, cb

invokeWrapper.serial   = invokeSerial
invokeWrapper.parallel = invokeParallel

# Overwrite invoke and task
global.invoke = invokeWrapper
global.task   = task

# Expose helpers
global.exec    = exec
global.running = running

module.exports =
  exec:           exec
  invoke:         invoke
  invokeParallel: invokeParallel
  invokeSerial:   invokeSerial
  running:        running

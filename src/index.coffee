# Used in literally every Cakefile I write so exported here as a global for easy access.
global.exec = exec = require 'executive'

# CoffeeScript 1.7.0 breaks the ability to require other CoffeeScript modules
# in your Cakefile, fix this.
[major, minor] = (require 'coffee-script/package').version.split '.'
if major == 1 and 8 > minor >= 7
  require 'coffee-script/register'

# Get proper stack traces
require('source-map-support').install()

# references to original invoke, task
cakeInvoke = global.invoke
cakeTask   = global.task

tasks = {}

# our Task takes an optional callback to signal when a task is completed
global.task = (name, description, deps, action) ->
  # Alternately support deps as an extra argument
  unless typeof action is 'function'
    [action, deps] = [deps, []]

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
    # If task's action expects two arguments order is (options, callback).
    if action.length == 2
      action options, cb

    # If task's action expects a single argument named callback, cb, or done, or
    # next it expects (callback) and no options object.
    else if /^function \((callback|cb|done|next)\)/.test action.toString()
      action cb

    # Unspecified, or expects (options).
    else
      cb action options

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

# wrapper
global.invoke = (task, cb = ->) ->
  if Array.isArray task
    invokeSerial task, cb
  else
    invoke task, cb

# expose serial/parallel
global.invoke.serial = invokeSerial
global.invoke.parallel = invokeParallel

module.exports =
  exec: exec
  invoke: invoke
  invokeSerial: invokeSerial
  invokeParallel: invokeParallel

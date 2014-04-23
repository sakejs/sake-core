# Used in literally every Cakefile I write so exported here as a global for easy access.
global.exec = exec = require 'executive'

# CoffeeScript 1.7.0 breaks the ability to require other CoffeeScript modules
# in your Cakefile, fix this.
require 'coffee-script/register'

# Get proper stack traces
require('source-map-support').install()

# references to original invoke, task
cakeInvoke = global.invoke
cakeTask   = global.task

tasks = {}

# Our invoke takes a callback which should be called when a task has completed.
invoke = (name, cb) ->
  # Call original invoke to set options for our task.
  cakeInvoke name

  {action, options} = tasks[name]

  # Pass right arguments to task
  if /function \(done\)/.test action
    action cb
  else
    action options, cb

# our Task takes an optional callback to signal when a task is completed
global.task = (name, description, action) ->
  # store reference for ourselves
  tasks[name] = {action, description, name}

  # make sure original plumbing still works, inject our shim task
  cakeTask name, description, (options) ->
    # we capture result of options for our own invoke step
    tasks[name].options = options

# Invoke wrapper that lets us handle a series of tasks when passed an array.
global.invoke = (tasks, callback = ->) ->
  unless Array.isArray tasks
    tasks = [tasks]

  do (next = ->
    unless tasks.length
      callback()
    else
      invoke tasks.shift(), next)

module.exports =
  exec: exec
  invoke: invoke

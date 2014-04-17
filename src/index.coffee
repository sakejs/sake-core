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

# our Task takes an optional callback to signal when a task is completed
global.task = (name, description, action) ->
  # store reference for ourselves
  tasks[name] = {action, description, name}

  # make sure original plumbing still works, inject our shim task
  cakeTask name, description, (options) ->
    # we capture result of options for our own invoke step
    tasks[name].options = options

# Our invoke takes an optional callback which will be called when task is completed
global.invoke = (name, done) ->
  # call original invoke to set options for our task
  cakeInvoke name

  {action, options} = tasks[name]

  if typeof done != 'function'
    done = ->

  if /function \(done\)/.test action
    # only expects single argument, done
    action done
  else
    action options, done

module.exports =
  exec: exec

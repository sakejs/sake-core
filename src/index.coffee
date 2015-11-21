require 'coffee-script/register'
require 'source-map-support/register'

# Save references to original invoke, task
cakeInvoke = global.invoke
cakeTask   = global.task

# We share tasks between our custom invoke, task
tasks = {}

# Use our invoke, task
global.invoke = (require './invoke') tasks, cakeInvoke
global.task   = (require './task')   tasks, cakeTask

# Helpers
global.exec    = require __dirname + '/../node_modules/executive'
global.running = require './running'

module.exports =
  exec:    global.exec
  invoke:  global.invoke
  running: global.running
  task:    global.task

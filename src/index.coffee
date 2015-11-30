require 'postmortem/register'

global.task    = require './task'
global.invoke  = require './invoke'
global.running = require './running'

global.exec    = require 'executive'

module.exports =
  exec:    global.exec
  invoke:  global.invoke
  running: global.running
  task:    global.task

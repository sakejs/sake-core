require 'coffee-script/register'
require 'postmortem/register'

global.exec    = require 'executive'

global.invoke  = require './invoke'
global.running = require './running'
global.task    = require './task'

module.exports =
  exec:    global.exec
  invoke:  global.invoke
  running: global.running
  task:    global.task

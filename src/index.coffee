require 'postmortem/register'

path = require 'path'

# Ensure local node_modules bin is on the front of $PATH
binPath = path.join process.cwd(), 'node_modules/', '.bin'

process.env.PATH = ([binPath].concat process.env.PATH.split ':').join ':'

global.task    = require './task'
global.invoke  = require './invoke'
global.running = require './running'

global.exec    = require 'executive'


module.exports =
  exec:    global.exec
  invoke:  global.invoke
  running: global.running
  task:    global.task

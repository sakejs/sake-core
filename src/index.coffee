require 'postmortem/register'

path = require 'path'

# Ensure local node_modules bin is on the front of $PATH
binPath = path.join process.cwd(), 'node_modules/', '.bin'

process.env.PATH = ([binPath].concat process.env.PATH.split ':').join ':'

global.invoke  = require './invoke'
global.running = require './running'
global.task    = require './task'
global.tasks   = require './tasks'
global.use     = require './use'

global.exec    = require 'executive'


module.exports =
  exec:    global.exec
  invoke:  global.invoke
  running: global.running
  task:    global.task
  tasks:   global.tasks
  use:     global.use

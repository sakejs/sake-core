require 'postmortem/register'

path = require 'path'

# Ensure local node_modules bin is on the front of $PATH
binPath = path.join process.cwd(), 'node_modules/', '.bin'

process.env.PATH = ([binPath].concat process.env.PATH.split ':').join ':'

global.cp      = require 'cp'
global.exec    = require 'executive'
global.invoke  = require './invoke'
global.running = require './running'
global.task    = require './task'
global.tasks   = require './tasks'
global.use     = require './use'

module.exports =
  cp:      cp
  exec:    exec
  invoke:  invoke
  running: running
  task:    task
  tasks:   tasks
  use:     use

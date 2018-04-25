import exec   from 'executive'
import {join} from 'path'

import invoke   from './invoke'
import option   from './option'
import options  from './options'
import parallel from './invoke/parallel'
import running  from './running'
import serial   from './invoke/serial'
import task     from './task'
import tasks    from './tasks'
import use      from './use'
import watch    from './watch'

import {version} from '../package.json'

install = ->
  # Ensure local node_modules bin is on the front of $PATH
  binPath = join process.cwd(), 'node_modules/', '.bin'
  process.env.PATH = ([binPath].concat process.env.PATH.split ':').join ':'

  global.invoke  = invoke
  global.option  = option
  global.options = options
  global.running = running
  global.task    = task
  global.tasks   = tasks
  global.use     = use

  global.watch   = watch # Deprecated
  global.exec    = exec  # Deprecated

export {
  install
  invoke
  option
  options
  parallel
  running
  serial
  task
  tasks
  use
  version
  watch
}

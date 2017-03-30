import 'postmortem/register'

import exec   from 'executive'
import path   from 'path'
import vigil  from 'vigil'

import cp      from './cp'
import invoke  from './invoke'
import running from './running'
import task    from './task'
import tasks   from './tasks'
import use     from './use'


# Ensure local node_modules bin is on the front of $PATH
binPath = path.join process.cwd(), 'node_modules/', '.bin'

process.env.PATH = ([binPath].concat process.env.PATH.split ':').join ':'

global.cp      = cp
global.exec    = exec
global.invoke  = invoke
global.running = running
global.task    = task
global.tasks   = tasks
global.use     = use
global.walk    = vigil.walk
global.watch   = vigil.watch

export {cp, exec, invoke, running, task, tasks, use}

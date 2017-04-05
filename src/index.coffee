import invoke  from './invoke'
import running from './running'
import task    from './task'
import tasks   from './tasks'
import use     from './use'

install = ->
  global.invoke  = invoke
  global.running = running
  global.task    = task
  global.tasks   = tasks
  global.use     = use

export {
  install
  invoke
  running
  task
  tasks
  use
}

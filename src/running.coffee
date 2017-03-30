import log from './log'

# Keep track of running tasks
runningTasks = {}

running = (name) ->
  return runningTasks[name]

running.start = (name) ->
  log.info 'running', name
  runningTasks[name] = true

running.stop = (name) ->
  log.info 'stopped', name
  runningTasks[name] = false

export default running

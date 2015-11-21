# Keep track of running tasks
runningTasks = {}

running = (name) ->
  return runningTasks[name]

running.start = (name) ->
  runningTasks[name] = true

running.stop = (name) ->
  runningTasks[name] = false

module.exports = running

# Keep track of running tasks
tasks = {}

running = (name) ->
  return tasks[name]

running.start = (name) ->
  tasks[name] = true

running.stop = (name) ->
  tasks[name] = false

module.exports = running

# Global task cache
tasks = {}
tasks.has = (key) ->
  tasks[key]?

module.exports = tasks

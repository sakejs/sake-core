# Global task cache
tasks = {}

tasks.has = (key) ->
  tasks[key]?

export default tasks

{isFunction} = require './utils'

module.exports = (tasks = {}, cakeTask = global.task) ->
  # Our `task` can optionally specify dependencies or a callback if it's
  # asynchronous

  task = (name, description, deps, action) ->
    # No dependencies specified, ex: `task 'name', 'description', ->`
    if typeof deps is 'function'
      [action, deps] = [deps, []]

    # Missing task function (body), ex: `task 'name', 'description', ['1','2','3']`
    unless isFunction action
      action = ->

    # store reference for ourselves
    tasks[name] = {name, description, deps, action}

    # make sure original plumbing still works, inject our shim task
    cakeTask name, description, (options) ->
      # we capture result of options for our own invoke step
      tasks[name].options = options

  task

cake  = require './cake'
tasks = require './tasks'

{isFunction} = require './utils'

module.exports = (name, description, deps, action) ->
  # No dependencies specified, ex: `task 'name', 'description', ->`
  if typeof deps is 'function'
    [action, deps] = [deps, []]

  # Missing task function (body), ex: `task 'name', 'description', ['1','2','3']`
  unless isFunction action
    action = ->

  # store reference for ourselves
  tasks[name] = {name, description, deps, action}

  # make sure original plumbing still works, inject our shim task
  cake.task name, description, (options) ->
    # we capture result of options for our own invoke step
    tasks[name].options = options

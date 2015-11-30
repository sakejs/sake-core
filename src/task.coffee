cake  = require './cake'
tasks = require './tasks'

{isArray, isFunction} = require './utils'

module.exports = (name, description, deps, action) ->
  # If we're passed name, action
  if isFunction description
    [action, description, deps] = [description, '', []]

  # No description, just deps
  if isArray description
    [description, deps] = ['', description]

  # No dependencies specified, ex: `task 'name', 'description', ->`
  if isFunction deps
    [action, deps] = [deps, []]

  # Missing task function (body), ex: `task 'name', 'description', ['1','2','3']`
  unless isFunction action
    action = ->

  # Store reference for ourselves
  tasks[name] = {name, description, deps, action}

  # Make sure original plumbing still works, inject our shim task
  cake.task name, description, (options) ->
    # Capture result of options for our own `invoke`
    tasks[name].options = options

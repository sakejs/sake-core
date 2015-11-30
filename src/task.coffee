cake  = require './cake'
log   = require './log'
tasks = require './tasks'

{isArray, isFunction} = require './utils'

module.exports = (name, description, deps, action) ->
  # No description, just deps
  if isArray description
    action = deps if isFunction deps
    [description, deps] = ['', description]

  # If we're passed name, action
  if isFunction description
    [action, description, deps] = [description, '', []]

  # No dependencies specified, ex: `task 'name', 'description', ->`
  if isFunction deps
    [action, deps] = [deps, []]

  # Missing task function (body), ex: `task 'name', 'description', ['1','2','3']`
  unless isFunction action
    action = ->

  # Store reference for ourselves
  tasks[name] =
    name:        name
    description: description
    deps:        deps
    action:      action

  log.debug 'added task', tasks[name]

  # Make sure original plumbing still works, inject our shim task
  cake.task name, description, (options) ->
    # Capture result of options for our own `invoke`
    tasks[name].options = options

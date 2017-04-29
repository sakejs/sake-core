import isArray    from 'es-is/array'
import isFunction from 'es-is/function'

import log   from './log'
import tasks from './tasks'

export default (name, description, deps, action) ->
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

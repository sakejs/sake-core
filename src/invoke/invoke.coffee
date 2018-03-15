import isFunction          from 'es-is/function'
import isGeneratorFunction from 'es-is/generator-function'

import log   from '../log'
import tasks from '../tasks'

import invokeAsync     from './async'
import invokeGenerator from './generator'
import invokeSync      from './sync'
import serial          from './serial'

invoked = {}

# Invoke delegates to one of the above
invoke = (name, opts, cb) ->
  log.debug 'invoke', name, opts

  # Prevent recursive calls
  return if invoked[name]
  invoked[name] = true

  unless (task = tasks[name])?
    throw new Error "No such task: #{name}"

  # Grab task action, any deps and parsed options
  {action, deps} = tasks[name]

  done = (err) ->
    invoked = {}
    (cb err) if isFunction cb

  invokeAction = (err) ->
    return done err if err?

    # Is a generator task
    if isGeneratorFunction action
      return invokeGenerator name, action, opts, done

    # Two arguments, action expects callback
    if action.length == 2
      return invokeAsync name, action, opts, done

    # Single argument, detected callback
    if /^function \((callback|cb|done|next)\)/.test action
      return invokeAsync name, action, null, done

    # 0 or 1 argument action, no callback detected
    invokeSync name, action, opts, done

  # Process deps first if any
  return serial deps, opts, invokeAction

  invokeAction()

export default invoke

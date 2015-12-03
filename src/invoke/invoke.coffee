cake  = require '../cake'
log   = require '../log'
tasks = require '../tasks'

# Invoke a enerator task continually until consumed
invokeGenerator = require './generator'
invokeAsync     = require './async'
invokeSync      = require './sync'

{isFunction, isGeneratorFn} = require '../utils'

invoked = {}

# Invoke delegates to one of the above
invoke = (name, opts, cb) ->
  log.debug 'invoke'

  return if invoked[name]
  invoked[name] = true

  # Calling cake's invoke ensures that options are passed to us correctly as
  # well as ensuring the normal missing task error is shown.
  cake.invoke name

  # Grab task action, any deps and parsed options
  {action, deps, options} = tasks[name]

  # Extend caller provided parsed options
  opts = Object.assign options, opts

  done = (err) ->
    invoked = {}
    (cb err) if isFunction cb

  invokeAction = (err) ->
    return done err if err?

    # Is a generator task
    if isGeneratorFn action
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
  return require('./serial') deps, opts, invokeAction

  invokeAction()

module.exports = invoke

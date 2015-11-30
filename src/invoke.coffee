cake    = require './cake'
running = require './running'
tasks   = require './tasks'
log     = require './log'

{
  isArray
  isAsyncFunction
  isFunction
  isGeneratorFn
  isPromise
} = require './utils'


# Invoke a enerator task continually until consumed
invokeGenerator = (name, action, opts, cb) ->
  log.debug 'invokeGenerator', name

  running.start name

  gen = action opts

  last = null
  prev = null

  done = (err) ->
    running.stop name
    cb err, (last ? prev)

  next = (value) ->
    try
      res = gen.next value
    catch err
      return done err

    prev = last
    last = res.value

    if isPromise promise = res.value
      promise
        .then (value) ->
          next value
        .catch (err) ->
          done err
    else if not res.done
      next res.value
    else
      done()

  next()

# Invoke async task
invokeAsync = (name, action, opts, cb) ->
  log.debug 'invokeAsync', name

  running.start name

  done = ->
    running.stop name
    cb.apply null, arguments

  if opts?
    action opts, done
  else
    action done

# Invoke sync task
invokeSync = (name, action, opts, cb) ->
  log.debug 'invokeSync', name

  running.start name

  ret = action opts

  if isPromise promise = ret
    promise
      .then (value) ->
        running.stop name
        cb null, value
      .catch (err) ->
        running.stop name
        cb err
  else
    running.stop name
    cb null, ret

# Invoke delegates to one of the above
invoke = (name, opts, cb) ->
  log.debug 'invoke'

  # Calling cake's invoke ensures that options are passed to us correctly as
  # well as ensuring the normal missing task error is shown.
  cake.invoke name

  # Grab task action, any deps and parsed options
  {action, deps, options} = tasks[name]

  # Extend caller provided parsed options
  opts = Object.assign options, opts

  done = (err) ->
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
  return invokeSerial deps, opts, invokeAction

  invokeAction()

# Invoke tasks in serial
invokeSerial = (tasks, opts, cb) ->
  log.debug 'invokeSerial', tasks, opts

  serial = (cb) ->
    next = (err) ->
      return cb err if err?

      if tasks.length
        invoke tasks.shift(), opts, next
      else
        cb()
    next()

  return (serial cb) if isFunction cb

  new Promise (resolve, reject) ->
    serial (err) ->
      reject err if err?
      resolve()
      cb err

# Invoke tasks in serial
invokeParallel = (tasks, opts, cb) ->
  log.debug 'invokeParallel', tasks, opts

  parallel = (cb) ->
    done = 0
    for task in tasks
      invoke task, opts, ->
        if ++done == tasks.length
          cb()

  return (parallel cb) if isFunction cb

  new Promise (resolve, reject) ->
    parallel (err) ->
      reject err if err?
      resolve()
      cb err

# Wrap invokeSerial, invokeParallel to ensure sane arguments
wrap = (fn) ->
  (tasks, opts, cb) ->
    # Ensure tasks are an array
    tasks = [tasks] unless isArray tasks

    # Called with a callback and no options
    if isFunction opts
      [cb, opts] = [opts, {}]

    # Ensure opts exists
    opts ?= {}

    fn tasks, opts, cb

wrapper = wrap invokeSerial
wrapper.serial = wrapper
wrapper.parallel = wrap invokeParallel

module.exports = wrapper

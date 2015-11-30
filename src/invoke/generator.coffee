log     = require '../log'
running = require '../running'

{isPromise} = require '../utils'


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

module.exports = invokeGenerator

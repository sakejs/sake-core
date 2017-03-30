import log     from '../log'
import running from '../running'

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

export default invokeAsync

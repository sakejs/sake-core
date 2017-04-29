import chalk    from 'chalk'
import isString from 'es-is/string'

verbose = process.env.VERBOSE ? false

pretty = (obj) ->
  JSON.stringify obj, null, 2

logger = (method, color) ->
  prefix = chalk[color] method

  (args...) ->
    return unless verbose

    msg = prefix

    for arg in args
      if isString arg
        msg += ' ' + arg
      else
        msg += '\n' + pretty arg

    console.log msg

methods =
  debug:    'blue'
  info:     'white'
  warn:     'yellow'
  error:    'red'

  bebop:    'black'
  modified: 'cyan'
  compiled: 'blue'

wrapper = logger 'info', 'white'
for k,v of methods
  wrapper[k] = logger k,v

wrapper.verbose = (bool = !verbose) ->
  verbose = bool

export default wrapper

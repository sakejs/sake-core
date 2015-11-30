chalk      = require 'chalk'
{isString} = require './utils'

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

for k,v of methods
  exports[k] = logger k,v

exports.verbose = (bool = !verbose) ->
  verbose = bool

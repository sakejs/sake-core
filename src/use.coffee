task = require './task'

{option}               = require './cake'
{isFunction, isString} = require './utils'

module.exports = (pkg, opts) ->
  if isString pkg
    pkg = require pkg

    if opts?
      pkg = pkg opts
    else
      pkg = pkg() unless /function \(task/.test pkg

  if isFunction pkg
    return pkg task, option

  pkg

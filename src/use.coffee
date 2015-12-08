task = require './task'

{option}               = require './cake'
{isFunction, isString} = require './utils'

module.exports = (pkg) ->
  if isString pkg
    pkg = require pkg

  if isFunction pkg
    return pkg task, option

  pkg

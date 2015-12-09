{isFunction, isString} = require './utils'

module.exports = (pkg, opts = {}) ->
  if isString pkg
    pkg = require pkg

  if isFunction pkg
    pkg opts

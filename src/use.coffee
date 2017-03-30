import {isFunction, isString} from './utils'

export default (pkg, opts = {}) ->
  if isString pkg
    pkg = require pkg

  if isFunction pkg
    pkg opts

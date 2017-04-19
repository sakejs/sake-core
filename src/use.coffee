import resolve from 'resolve'
import {isFunction, isString} from 'es-is'

export default (pkg, opts = {}) ->
  if isString pkg
    path = resolve.sync pkg, basedir: process.cwd()
    pkg = require path

    # Support CJS formatted ES modules with named + default exports
    if pkg.default?
      pkg = pkg.default

  if isFunction pkg
    pkg opts

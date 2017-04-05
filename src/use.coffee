import resolve from 'resolve'

import {isFunction, isString} from './utils'

export default (pkg, opts = {}) ->
  if isString pkg
    path = resolve.sync pkg, basedir: process.cwd()
    pkg = require path

  if isFunction pkg
    pkg opts

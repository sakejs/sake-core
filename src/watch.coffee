import isFunction from 'es-is/function'
import isString   from 'es-is/string'
import vigil      from 'vigil'

export default (dir, task, opts = {}) ->
  if isString task
    fn = -> invoke task
  else if isFunction task
    fn = task
  vigil.watch dir, fn, opts

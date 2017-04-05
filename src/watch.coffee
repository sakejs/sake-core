import vigil from 'vigil'
import {isFunction, isString} from './utils'

export default (dir, task, opts = {}) ->
  if isString task
    fn = -> invoke task
  else if isFunction task
    fn = task
  vigil.watch dir, fn, opts

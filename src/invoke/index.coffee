import {isArray, isFunction} from 'es-is'

import parallel from './parallel'
import serial   from './serial'

# Wrap invokeSerial, invokeParallel to ensure sane arguments
wrap = (fn) ->
  (tasks, opts, cb) ->
    # Ensure tasks are an array
    tasks = [tasks] unless isArray tasks

    # Called with a callback and no options
    if isFunction opts
      [cb, opts] = [opts, {}]

    # Ensure opts exists
    opts ?= {}

    fn tasks, opts, cb

wrapper = wrap serial
wrapper.serial   = wrapper  # aliased
wrapper.parallel = wrap parallel

export default wrapper

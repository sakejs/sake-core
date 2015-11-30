{isArray, isFunction} = require '../utils'

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

wrapper = wrap require './serial'
wrapper.serial = wrapper  # aliased
wrapper.parallel = wrap require './parallel'

module.exports = wrapper

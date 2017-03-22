cp      = require 'cp'
path    = require 'path'
fs      = require 'fs'

{isFunction} = require './utils'

module.exports = (src, dst, opts, cb) ->
  if isFunction opts
    [opts, cb] = [{}, opts]

  opts ?= {}

  p = new Promise (resolve, reject) ->
    fs.stat dst, (err, stats) ->
      if stats.isDirectory
        dst = path.join dst, path.basename src

      cp src, dst, (err) ->
        if err?
          reject err
        else
          resolve()

  p.callback cb
  p

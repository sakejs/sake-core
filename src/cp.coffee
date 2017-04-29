import cp   from 'cp'
import path from 'path'
import fs   from 'fs'
import isFunction from 'es-is/function'

export default (src, dst, opts, cb) ->
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

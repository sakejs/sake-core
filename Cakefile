cake = require 'shortcake'
exec = require 'executive'

# done is a callback to signal you are done with a task
task 'compile:coffee', (done) ->
  exec 'cake -bcm -o lib/ src/', done

task 'minify:js', (done) ->
  exec 'uglify-js lib', done

# just async callbacks
task 'build', ->
  invoke 'compile:coffee', ->
    invoke 'minify:js'

# optionally pass list of tasks to invoke
task 'build', (options) ->
  invoke [
    'compile:coffee'
    'minify:js'
  ]

# allow per-task options (not sure about API)
options 'build', (option) ->
  option '-m', '--minify', 'minify during build'

# optionally pass list of tasks to invoke
task 'build', (options) ->
  invoke [
    'compile:coffee'
    'minify:js'
  ]

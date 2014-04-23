# shortcake [![Build Status](https://travis-ci.org/zeekay/shortcake.svg?branch=master)](https://travis-ci.org/zeekay/shortcake)
Shorten your Cakefiles and fix oddities in cake!

### Install
```
npm install -g shortcake
```

For best results `alias cake=shortcake` in your `~/.zshrc` or `~/.bashrc`.

### Usage
Just add `require 'shortcake'` at the top of your Cakefile!

### Changes from regular `cake`

Fixes the following behavior:

- Able to require CoffeeScript modules from Cakefiles automatically.
- Natural command line arguments when using `shortcake` executable, i.e., this
  works: `cake build --minify`
- Better stacktraces, source map support

Adds the following:
- Tasks can be passed an optional callback, allowing async tasks to be chained
  easily.

### Examples

```coffeescript
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
```

### Future
Eventually I'd like to be able to do something like this:
```coffeescript
# allow per-task options (API not finalized)
options 'build', (option) ->
  option '-m', '--minify', 'minify during build'

# optionally pass list of tasks to invoke
task 'build', (options) ->
  steps = ['compile:coffee']

  if options.minify
      steps.push 'minify:js'

  invoke steps
```

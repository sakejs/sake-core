cake  = require 'shortcake'
path  = require 'path'
vigil = require 'vigil'

option '-g', '--grep [filter]', 'test filter'
option '-t', '--test',          'test specific module'
option '-w', '--watch',         'watch for changes and re-run tests'

task 'build', 'compile src/*.coffee to lib/*.js', ->
  exec 'node_modules/.bin/coffee -bcm -o lib/ src/'
  exec 'node_modules/.bin/coffee -bcm -o .test test/'

task 'watch', 'watch for changes and recompile project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'
  exec 'node_modules/.bin/coffee -bcmw -o .test test/'

task 'gh-pages', 'Publish github page', ->
  require('brief').update()

task 'test', 'run tests', (options) ->
  args = []

  if options.grep?
    args.push "--grep #{options.grep}"

  if options.watch?
    args.push '--watch'

  options.test ?= '.test'

  exec "NODE_ENV=test node_modules/.bin/mocha
  --colors
  --reporter spec
  --timeout 5000
  --compilers coffee:coffee-script/register
  --require test/_helper.js
  #{args.join ' '}
  #{options.test}"

task 'publish', 'Publish project', ->
  exec [
    'cake build'
    'git push'
    'npm publish'
  ]

task 'test:watch', 'watch for changes and recompile, re-run tests', (options) ->
  vigil.watch __dirname, (filename, stats) ->
    if /\.coffee$/.test filename

      if /^test/.test filename
        out = '.test/'
        options.test = ".test/#{path.basename filename.split '.', 1}.js"
      else if /^src/.test filename
        out = 'lib/'
        options.test = '.test'
      else
        return

      exec "node_modules/.bin/coffee -bcm -o #{out} #{filename}", ->
        console.log "#{(new Date).toLocaleTimeString()} - compiled #{filename}"
        invoke 'test'

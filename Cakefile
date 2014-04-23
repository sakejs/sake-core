exec  = require('shortcake').exec.interactive
path  = require 'path'
vigil = require 'vigil'

option '-g', '--grep [filter]', 'test filter'
option '-t', '--test',          'test specific module'
option '-w', '--watch',         'watch for changes and re-run tests'

task 'build', 'compile src/*.coffee to lib/*.js', (done) ->
  exec ['node_modules/.bin/coffee -bcm -o lib/ src/'
        'node_modules/.bin/coffee -bcm -o .test test/'], done

task 'watch', 'watch for changes and recompile project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'
  exec 'node_modules/.bin/coffee -bcmw -o .test test/'

task 'test', 'run tests', (options, done) ->
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
  --require postmortem/register
  #{args.join ' '}
  #{options.test}", done

task 'watch:test', 'watch for changes and recompile, re-run tests', (options) ->
  runningTests = false

  invoke 'test', ->
    require('vigil').watch __dirname, (filename, stats) ->
      return if runningTests

      if /\.coffee$/.test filename
        if /^test/.test filename
          out = '.test/'
          options.test = ".test/#{path.basename filename.split '.', 1}.js"
        else if /^src/.test filename
          out = (path.dirname filename).replace /^src/, 'lib'
          options.test = '.test'
        else
          return

        runningTests = true
        exec "node_modules/.bin/coffee -bcm -o #{out} #{filename}", ->
          process.stdout.write "#{(new Date).toLocaleTimeString()} - compiled #{filename}"
          invoke 'test', ->
            runningTests = false

task 'gh-pages', 'Publish github page', ->
  require('brief').update()

task 'publish', 'Publish project', ->
  exec ['git push', 'npm publish', 'cake gh-pages']

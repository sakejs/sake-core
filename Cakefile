require 'coffee-script/register'
exec = require('./src').exec.interactive
path = require 'path'

option '-g', '--grep [filter]', 'test filter'
option '-t', '--test',          'test specific module'

task 'build', 'build project', (done) ->
  exec 'node_modules/.bin/coffee -bcm -o lib/ src/', done

task 'watch', 'watch for changes and rebuild project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'

task 'test', 'run tests', (opts, done) ->
  grep = if opts.grep then "--grep #{opts.grep}" else ''
  test = opts.test ? 'test'

  invoke 'build', ->
    exec "NODE_ENV=test node_modules/.bin/mocha
                        --colors
                        --reporter spec
                        --timeout 5000
                        --compilers coffee:coffee-script/register
                        --require source-map-support/register
                        #{grep}
                        #{test}", done

task 'watch:test', 'watch for changes and rebuild, rerun tests', (options) ->
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
  exec [
    'git push'
    'git push --tags'
    'npm publish'
  ], ->
    invoke gh-pages

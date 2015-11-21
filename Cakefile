require './lib'

option '-g', '--grep [filter]', 'test filter'
option '-t', '--test',          'test specific module'

task 'build', 'build project', (done) ->
  exec 'node_modules/.bin/coffee -bcm -o lib/ src/', done

task 'test', 'run tests', (opts, done) ->
  grep = if opts.grep then "--grep #{opts.grep}" else ''
  test = opts.test ? 'test/'

  exec "NODE_ENV=test node_modules/.bin/mocha
                      --colors
                      --reporter spec
                      --timeout 5000
                      --compilers coffee:coffee-script/register
                      --require source-map-support/register
                      #{grep}
                      #{test}", done

task 'watch', 'watch for changes and rebuild project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'

task 'watch:test', 'watch for changes and rebuild, rerun tests', (options) ->
  invoke 'watch'

  require('vigil').watch __dirname, (filename, stats) ->
    return if running 'test'

    if /^test/.test filename
      options.test = filename
    if /^src/.test filename
      options.test = 'test'

    invoke 'test'

task 'publish', 'Publish project', ->
  # require('brief').update()

  exec 'git push'
  exec 'git push --tags'
  exec 'npm publish'

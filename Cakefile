require './lib'

option '-g', '--grep [filter]', 'test filter'
option '-t', '--test',          'test specific module'

task 'build', 'build project', ->
  yield exec 'node_modules/.bin/coffee -bcm -o lib/ src/'

task 'test', 'run tests', (opts) ->
  grep = if opts.grep then "--grep #{opts.grep}" else ''
  test = opts.test ? 'test/'

  yield exec "NODE_ENV=test node_modules/.bin/mocha
                      --colors
                      --reporter spec
                      --timeout 5000
                      --compilers coffee:coffee-script/register
                      --require postmortem/register
                      --require co-mocha
                      #{grep}
                      #{test}"

task 'watch', 'watch for changes and rebuild project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'

task 'watch:test', 'watch for changes and rebuild, rerun tests', (options) ->
  invoke 'watch'

  require('vigil').watch __dirname, (filename, stats) ->
    return if running 'test'

    if /^src/.test filename
      invoke 'test'

    if /^test/.test filename
      invoke 'test', test: filename

task 'publish', 'Publish project', ->
  # require('brief').update()

  exec '''
  git push
  git push --tags
  npm publish
  '''

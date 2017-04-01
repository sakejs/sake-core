require './'

option '-g', '--grep [filter]', 'test filter'
option '-t', '--test',          'test specific module'

use 'cake-bundle'
use 'cake-version'
use 'cake-publish'
use 'cake-outdated'

task 'build', 'build project', ->
  b = new Bundle
    compilers:
      coffee:
        version: 1

  Promise.all [
    b.write
      entry: 'src/index.coffee'
    b.write
      entry:  'src/cli.coffee'
      format: 'cjs'
      dest:   'lib/cli.js'
  ]

task 'test', 'run tests', (opts) ->
  grep = if opts.grep then "--grep #{opts.grep}" else ''
  test = opts.test ? 'test/'

  exec "NODE_ENV=test mocha
                      --colors
                      --reporter spec
                      --timeout 5000
                      --compilers coffee:coffee-script/register
                      --require postmortem/register
                      --require co-mocha
                      #{grep}
                      #{test}"

task 'watch', 'watch for changes and rebuild project', ->
  exec 'coffee -bcmw -o lib/ src/'

task 'watch:test', 'watch for changes and rebuild, rerun tests', (options) ->
  invoke 'watch'

  require('vigil').watch __dirname, (filename, stats) ->
    return if running 'test'

    if /^src/.test filename
      invoke 'test'

    if /^test/.test filename
      invoke 'test', test: filename

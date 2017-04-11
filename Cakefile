use 'sake-bundle'
use 'sake-outdated'
use 'sake-publish'
use 'sake-test'
use 'sake-version'

task 'build', 'build project', ->
  b = new Bundle
    compilers:
      coffee: version: 1

  Promise.all [
    b.write
      entry: 'src/index.coffee'
    b.write
      entry:  'src/install.coffee'
      dest:   'install.js'
      format: 'cjs'
      sourceMap: false
  ]

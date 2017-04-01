# shortcake [![NPM version][npm-img]][npm-url] [![Build Status][travis-img]][travis-url] [![Coverage Status][coveralls-img]][coveralls-url] [![Dependency Status][dependency-img]][dependency-url] [![Gitter chat][gitter-img]][gitter-url]

Adds asynchronous tasks, generators, promises, dependencies and more to
[Cake](http://coffeescript.org/documentation/docs/cake.html).

### Features
- Asynchronous tasks are fully supported and composable.
- Generator based-control flow for tasks with full support for Promises.
- Tasks can declare dependencies and ensure they execute successfully first.
- You can require CoffeeScript files from your Cakefile automatically.
- More natural CLI (options can be specified last, i.e.: `cake build --minify`).
- Better stacktraces with source map support for CoffeeScript files.
- Additional helpers to make writing tasks faster and more pleasant.

### Install
```
npm install -g shortcake
```

For best results `alias cake=shortcake` in your `~/.zshrc` or `~/.bashrc`.

### Usage
Just add `require 'shortcake'` at the top of your Cakefile!


### Examples
#### Async tasks
Async tasks are easy to declare, any task with an obvious callback will be
treated as asynchronous. Add an additional argument called `callback`, `cb`,
`done` or `next` and use it to indicate when your task is finished executing.

```coffee
task 'compile:js', 'compile js', (done) ->
  exec 'coffee -bc app.coffee', done

task 'minify:js',   'minify js', (done) ->
  exec 'uglify-js --compress --mangle app.js > app.min.js', done
```

#### Promise tasks
You can also return a promise from your task and shortcake will automatically
wait for it to resolve. Since `executive` returns a promise, this works too:

```coffee
task 'compile:js', 'compile js', ->
  exec 'coffee -bc app.coffee'
```

#### Invoking multiple tasks
You can manually invoke tasks and string them together with callbacks:

```coffee
task 'build', 'build project', ->
  invoke 'compile:js', ->
    invoke 'minify:js'
```

#### Declaring dependencies
Dependencies can be declared by adding an array of task names after your task's
description.

```coffee
task 'build', 'build project', ['compile:js', 'minify:js']
```

#### Serial tasks
You can also pass an array of tasks `invoke` and it will execute them in order
for you:

```coffee
task 'build', 'build project', (done) ->
  invoke ['compile:js', 'minify:js'], done
```

...or more explicitly using `invoke.serial`.

#### Parallel tasks
If you want to execute tasks in parallel you can use `invoke.parallel`.

```coffee
task 'compile', 'compile css & js', (done) ->
  invoke.parallel ['compile:css', 'compile:js'], done
```

#### Detecting running tasks
You can check for running tasks using the `running` helper.

```coffee
task 'watch', 'watch for changes and re-compile js', ->
  exec 'coffee -bcmw -o lib/ src/'

task 'watch:test', 'watch for changes and re-run tests', (options) ->
  invoke 'watch'

  require('vigil').watch __dirname, (filename, stats) ->
    return if running 'test'

    if /^test/.test filename
      invoke 'test', test: filename
    if /^src/.test filename
      invoke 'test'
```

#### Generator tasks
You can also use `yield` to wait for the value of a promise and eschew the use
of callbacks.

```coffee
task 'compile:js', 'compile js', ->
  yield exec 'coffee -bc app.coffee'

task 'minify:js',   'minify js', ->
  yield exec 'uglify-js --compress --mangle app.js > app.min.js'
```

This really pays dividends with more complicated tasks:

```coffee
task 'package', 'Package project', ->
  yield exec '''
    mkdir -p dist
    rm   -rf dist/*
  '''

  yield exec.parallel '''
    cp manifest.json dist
    cp -rf assets    dist
    cp -rf lib       dist
    cp -rf views     dist
  '''

  yield exec '''
    zip -r package.zip dist
    rm -rf dist
  '''
```

#### More
You can peruse [shortcake's
Cakefile](https://github.com/zeekay/shortcake/blob/master/Cakefile) for a real
world example.

[travis-img]:     https://img.shields.io/travis/zeekay/referential.svg
[travis-url]:     https://travis-ci.org/zeekay/referential
[coveralls-img]:  https://coveralls.io/repos/zeekay/referential/badge.svg?branch=master&service=github
[coveralls-url]:  https://coveralls.io/github/zeekay/referential?branch=master
[dependency-url]: https://david-dm.org/zeekay/referential
[dependency-img]: https://david-dm.org/zeekay/referential.svg
[npm-img]:        https://img.shields.io/npm/v/referential.svg
[npm-url]:        https://www.npmjs.com/package/referential
[gitter-img]:     https://badges.gitter.im/join-chat.svg
[gitter-url]:     https://gitter.im/zeekay/hi

<!-- not used -->
[downloads-img]:     https://img.shields.io/npm/dm/referential.svg
[downloads-url]:     http://badge.fury.io/js/referential
[devdependency-img]: https://david-dm.org/zeekay/referential/dev-status.svg
[devdependency-url]: https://david-dm.org/zeekay/referential#info=devDependencies

# Sake

[![npm][npm-img]][npm-url]
[![build][build-img]][build-url]
[![dependencies][dependencies-img]][dependencies-url]
[![downloads][downloads-img]][downloads-url]
[![license][license-img]][license-url]
[![chat][chat-img]][chat-url]

> It is cold, but · we have Sake · and the hot spring

Sake is a build tool and task runner for JavaScript. Sake features an extensible
core and support for modern JS. Inspired by
[Cake](http://coffeescript.org/documentation/docs/cake.html), Sake is the
perfect DSL for building projects.

### Features
- Additional helpers to make writing tasks faster and more pleasant.
- Generator based-control flow in tasks with full support for Promises.
- Intutive CLI and automatic option parsing.
- Plugin architecture with available plugins for many common build tasks.
- Tasks can declare dependencies and be easily composed of and interact with
  other tasks.
- Modern JS support:
    - Async/Await
    - ES modules
    - Generators
    - Promises

### Install
```
npm install sake-core --save-dev
```

### Usage
Typically Sake is used via it's command line interface which can be installed
with `npm install -g sake-cli`. Once the [`sake`][sake-cli] command is
available, you can begin writing a `Sakefile` and defining available tasks in
your project.

### Sakefile
Sake will search for a Sakefile with tasks defined for your current project.
Sakefiles can be written in ES2015 JavaScript and support modules natively.

Optionally, you can write your Sakefile in CoffeeScript, which allows a very
nice DSL-ish experience.

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
You can also return a promise from your task and sake will automatically
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

### Using Sake with Cake
You can upgrade any Cakefile into a Sakefile by requiring `sake-core` at the top
of your Cakefile.

#### More
You can peruse Sake's [Sakefile][sakefile] for a real world example.

## License
[BSD-3-Clause][license-url]

[sake-cli]:         https://github.com/sakejs/sake-cli
[sakefile]:         https://github.com/sakejs/sake-core/blob/master/Sakefile

[build-img]:        https://img.shields.io/travis/sakejs/sake-core.svg
[build-url]:        https://travis-ci.org/sakejs/sake-core
[chat-img]:         https://badges.gitter.im/join-chat.svg
[chat-url]:         https://gitter.im/sakejs/chat
[coverage-img]:     https://coveralls.io/repos/sakejs/sake-core/badge.svg?branch=master&service=github
[coverage-url]:     https://coveralls.io/github/sakejs/sake-core?branch=master
[dependencies-img]: https://david-dm.org/sakejs/sake-core.svg
[dependencies-url]: https://david-dm.org/sakejs/sake-core
[downloads-img]:    https://img.shields.io/npm/dm/sake-core.svg
[downloads-url]:    http://badge.fury.io/js/sake-core
[license-img]:      https://img.shields.io/npm/l/sake-core.svg
[license-url]:      https://github.com/sakejs/sake-core/blob/master/LICENSE
[npm-img]:          https://img.shields.io/npm/v/sake-core.svg
[npm-url]:          https://www.npmjs.com/package/sake-core

# shortcake [![Build Status](https://travis-ci.org/zeekay/shortcake.svg?branch=master)](https://travis-ci.org/zeekay/shortcake)
Asynchronous invoke, dependencies and other goodies for cake.

### Features
- Tasks can declare dependencies and ensure they execute successfully first.
- Asynchronous tasks are fully supported and composable.
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
Use the `done` callback in a task's action to indicate when it's done executing:

```coffee
task 'compile', 'compile src/', (done) ->
  exec 'cake -bcm -o lib/ src/', done

task 'minify', 'minify lib/', (done) ->
  exec 'uglify-js lib', done
```

#### Declaring dependencies
Now you can declare dependencies similar to make:

```coffee
task 'build', 'build project', ['compile', 'minify']
```

#### Invoking multiple tasks
You can manually invoke tasks and string them together with callbacks:

```coffee
task 'build', 'build project', ->
  invoke 'build:compile', ->
    invoke 'build:minify'
```

#### Serial tasks
You can pass an array of tasks `invoke` and it will execute them in order
for you:

```coffee
task 'build', 'build project', ->
  invoke ['build:compile', 'build:minify'], ->
    console.log 'build finished'
```
...or more explicitly using `invoke.serial`.

#### Parallel tasks
If you need to execute tasks in parallel you can use `invoke.parallel`.

```coffee
task 'build', 'build project', ->
  invoke ['build:compile', 'build:minify'], ->
    console.log 'build finished'
```

#### Detecting running tasks
You can check for running tasks using the `running` helper.

```coffee
task 'watch:test', 'watch for changes and rebuild, rerun tests', (options) ->
  invoke 'watch'

  require('vigil').watch __dirname, (filename, stats) ->
    return if running 'test'

    if /^test/.test filename
      options.test = filename
    if /^src/.test filename
      options.test = 'test'

    invoke 'test'
```

#### More
You can peruse [shortcake's
Cakefile](https://github.com/zeekay/shortcake/blob/master/Cakefile) for a real
world example.

# shortcake [![Build Status](https://travis-ci.org/zeekay/shortcake.svg?branch=master)](https://travis-ci.org/zeekay/shortcake)
Asynchronous invoke, dependencies and other goodies for cake.

### Install
```
npm install -g shortcake
```

For best results `alias cake=shortcake` in your `~/.zshrc` or `~/.bashrc`.

### Usage
Just add `require 'shortcake'` at the top of your Cakefile!

### Changes from regular `cake`
- Tasks can declare other tasks as dependencies and require them to execute
  successfully first.
- Tasks can be passed an optional callback `done`, allowing async tasks to be
  chained easily.

Also fixes the following behavior:

- Able to require CoffeeScript modules from Cakefiles automatically.
- Natural command line arguments when using `shortcake` executable, i.e., this
  works: `cake build --minify`
- Better stacktraces, source map support

### Examples
Use the `done` callback in a task's action to indicate when it's done executing:
```coffee
task 'compile', 'compile src/', (done) ->
  exec 'cake -bcm -o lib/ src/', done

task 'minify', 'minify lib/', (done) ->
  exec 'uglify-js lib', done
```

Now you can declare dependencies similar to make:
```coffee
task 'build', 'build project', ['compile', 'minify']
```

You can also manually invoke tasks and string them together with callbacks:
```coffee
task 'build', 'build project', ->
  invoke 'build:compile', ->
    invoke 'build:minify'
```

You can also pass an array of tasks `invoke` and it will execute them in order
for you:
```coffee
task 'build', 'build project', ->
  invoke ['build:compile', 'build:minify'], ->
    console.log 'build finished'
```
...or more explicitly using `invoke.serial`.

If you need to execute tasks in parallel you can use `invoke.parallel`.

And of course you can peruse [shortcake's
Cakefile](https://github.com/zeekay/shortcake/blob/master/Cakefile) for a real
world example.

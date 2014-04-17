# shortcake
Shorten your Cakefiles and fix oddities in cake!

### Install
```
npm install -g shortcake
```

For best results `alias cake=shortcake` in your `~/.zshrc` or `~/.bashrc`.

### Usage
Just add `require 'shortcake'` at the top of your Cakefile!

### Changes from regular `cake`

Fixes the following behavior:

- Able to require CoffeeScript modules from Cakefiles automatically.
- Natural command line arguments when using `shortcake` executable, i.e., this
  works: `cake build --minify`
- Better stacktraces, source map support

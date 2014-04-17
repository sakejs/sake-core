# Used in literally every Cakefile I write so exported here as a global for easy access.
global.exec = exec = require 'executive'

# CoffeeScript 1.7.0 breaks the ability to require other CoffeeScript modules
# in your Cakefile, fix this.
require 'coffee-script/register'

module.exports =
  exec: exec

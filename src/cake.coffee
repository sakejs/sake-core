# Require cake in in case we haven't yet.
require 'coffee-script/lib/coffee-script/cake'

# Save references to original invoke, task
cakeInvoke = global.invoke
cakeTask   = global.task

module.exports =
  invoke: cakeInvoke
  task:   cakeTask

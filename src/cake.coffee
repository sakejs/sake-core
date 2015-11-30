unless global.task?
  require 'coffee-script/lib/coffee-script/cake'

# Save references to original invoke, task
cakeInvoke = global.invoke
cakeTask   = global.task

module.exports =
  invoke: cakeInvoke
  task:   cakeTask

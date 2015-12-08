unless global.task?
  require 'coffee-script/lib/coffee-script/cake'

# Save references to original invoke, task
cakeInvoke = global.invoke
cakeOption = global.option
cakeTask   = global.task

module.exports =
  invoke: cakeInvoke
  option: cakeOption
  task:   cakeTask

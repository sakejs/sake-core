import path from 'path'

cake      = null
cakePath  = 'coffee-script/lib/coffee-script/cake'
nodePaths = ['', '/usr/local/lib/node_modules', '/usr/lib/node_modules']

try
  coffeePath = require.resolve 'coffee-script'
  cake = require coffeePath.replace 'coffee-script.js', 'cake'
catch err
  do findCake = ->
    unless nodePaths.length
      console.error 'Cannot find module \'coffee-script\''
      process.exit 1

    try
      cake = require path.join nodePaths.shift(), cakePath
    catch err
      unless err.code is 'MODULE_NOT_FOUND'
        throw err
      else
        findCake()

# Setup process.argv for cake. If first argument to cake looks like a task,
# move it to end of arguments so cake agrees.
if process.argv[2] and process.argv[2].charAt(0) isnt '-'
  process.argv.push process.argv.splice(2, 1)[0]

# Run cake!
try
  cake.run()
catch err
  # Hide ugly traceback on common error.
  if /Cakefile not found in/.test err.message
    console.error err.message
  else
    throw err

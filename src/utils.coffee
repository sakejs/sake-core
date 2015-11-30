exports.isFunction = isFunction = (fn) ->
  typeof fn is 'function'

exports.isGenerator = (g) ->
  (isFunction g?.next) and (isFunction g.throw)

exports.isGeneratorFn = (fn) ->
  return false unless isFunction fn
  fn?.constructor?.name is 'GeneratorFunction'

exports.isPromise = (p) ->
  isFunction p?.then

exports.isArray = (a) ->
  Array.isArray a

exports.isString = (s) ->
  typeof s is 'string'

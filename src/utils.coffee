export isFunction = (fn) ->
  typeof fn is 'function'

export isGenerator = (g) ->
  (isFunction g?.next) and (isFunction g.throw)

export isGeneratorFn = (fn) ->
  return false unless isFunction fn
  fn?.constructor?.name is 'GeneratorFunction'

export isPromise = (p) ->
  isFunction p?.then

export isArray = (a) ->
  Array.isArray a

export isString = (s) ->
  typeof s is 'string'

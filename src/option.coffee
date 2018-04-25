import options from './options'

export default (letter, flag, description) ->
  unless description?
    [description, flag] = [flag, null]

  options[letter] =
    letter:      letter
    flag:        flag
    description: description

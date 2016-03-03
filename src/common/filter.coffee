fn =
  string: (value) ->
    (filter) ->
      return true unless filter?.length > 0
      value.toString().toLocaleLowerCase().indexOf(filter.toString().toLocaleLowerCase()) >= 0

  # object({a: 1, b: 2}, {a: 1})
  object: (value) ->
    (filter) ->
      return true unless filter?
      Object.keys(filter).all (key) ->
        fn.match(value[key])(filter[key])

  # array(["a", "b"], "b")
  array: (array) ->
    (filter) ->
      return true unless filter?
      array.filter((value) -> fn.match(value)(filter)).count() > 0

  value: (value) ->
    (filter) ->
      return true unless filter?
      value == filter

  match: (value) ->
    (filter) ->
      return true unless filter?

      if Object.isObject(value)
        fn.object(value)(filter)
      else if Object.isArray(value)
        fn.array(value)(filter)
      else if Object.isString(value)
        fn.string(value)(filter)
      else
        fn.value(value)(filter)

module.exports = (array) ->
  (filter) ->
    return array unless filter?
    array.filter (value) -> fn.match(value)(filter)

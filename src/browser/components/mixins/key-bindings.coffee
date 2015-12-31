KeyboardJS = require("keyboardjs")

module.exports =
  keyMap: []
  keyBindings: []

  bindKey: (key, fn) ->
    binding = (e) -> fn(e) unless ["INPUT", "TEXTAREA"].find(e.target.tagName)
    KeyboardJS.bind(key, binding)
    @keyBindings.push(binding)
    @keyMap.push(key)

  componentWillUnmount: ->
    @keyMap.each (key, index) =>
      KeyboardJS.bind(key, @keyBindings[index])

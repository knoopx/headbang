KeyboardJS = require("keyboardjs")

module.exports =
  keyMap: []
  keyBindings: []

  bindKey: (key, fn) ->
    KeyboardJS.bind(key, fn)
    @keyBindings.push(fn)
    @keyMap.push(key)

  componentWillUnmount: ->
    @keyMap.each (key, index) =>
      KeyboardJS.bind(key, @keyBindings[index])

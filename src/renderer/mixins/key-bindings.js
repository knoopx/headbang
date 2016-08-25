import KeyboardJS from 'keyboardjs'

export default {
  keyMap: [],
  keyBindings: [],
  bindKey(key, fn) {
    const binding = (e) => {
      if (!['INPUT', 'TEXTAREA'].find((value) => value === e.target.tagName)) {
        return fn(e)
      }
    }

    KeyboardJS.bind(key, binding)
    this.keyBindings.push(binding)
    return this.keyMap.push(key)
  },

  componentWillUnmount() {
    return this.keyMap.forEach((key, index) => {
      return KeyboardJS.bind(key, this.keyBindings[index])
    })
  }
}

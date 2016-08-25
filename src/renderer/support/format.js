export default {
  duration(input = 0) {
    const z = (n) => (n < 10 ? '0' : '') + n
    const seconds = Math.floor(input % 60)
    const minutes = Math.floor(input / 60)
    return `${z(minutes)}:${z(seconds)}`
  }
}

Axios = require("axios")
Immutable = require("immutable")

{EventEmitter2} = require('eventemitter2')
eventEmitter = new EventEmitter2(wildcard: true, delimiter: ':', maxListeners: 20)

module.exports = (endpoint, identityKey = "id") ->
  map = Immutable.Map()
  store =
    on: eventEmitter.on
    off: eventEmitter.off
    emit: eventEmitter.emit

    fetch: (params) ->
      Axios.get(endpoint, params: params).then (res) =>
        res.data.forEach(store.inject)
        res.data

    toArray: -> map.toArray()
    filter: (opts) -> map.filter(opts)
    sortBy: (opts) -> map.sortBy(opts)
    forEach: (fn) -> map.forEach(fn)

    get: (id) -> map.get(id)

    set: (id, newObj) ->
      map = map.set(id, newObj)
      store.emit("inject", newObj)
      store.emit("change")
      newObj

    unset: (id) ->
      obj = map.get(id)
      map = map.delete(id)
      store.emit("eject", obj)
      store.emit("change")
      obj

    inject: (newObj) ->
      throw new Error("missing primary key") unless newObj[identityKey]?
      store.set(newObj[identityKey], newObj)

    eject: (obj) ->
      if Object.isObject(obj)
        throw new Error("missing primary key") unless obj[identityKey]?
        store.unset(obj[identityKey])
      else
        store.unset(obj)

    ejectAll: ->
      store.toArray().forEach(store.eject)

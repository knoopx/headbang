Immutable = require("immutable")

Events = require("./service/events")

module.exports = (identityKey = "id") ->
  map = Immutable.Map()
  store =
    on: Events.on
    off: Events.off
    emit: Events.emit

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
      if Object.isObject(newObj)
        throw new Error("missing primary key") unless newObj[identityKey]?
        store.set(newObj[identityKey], newObj)
      else
        throw new Error("unexpected argument")

    eject: (obj) ->
      if Object.isObject(obj)
        throw new Error("missing primary key") unless obj[identityKey]?
        store.unset(obj[identityKey])
      else
        store.unset(obj)

    ejectAll: ->
      store.toArray().forEach(store.eject)

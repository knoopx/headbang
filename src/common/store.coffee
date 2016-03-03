Immutable = require("immutable")
{EventEmitter2} = require('eventemitter2')

filter = require("./filter")

class Store
  constructor: (@identityKey = "id") ->
    @eventEmitter = new EventEmitter2(wildcard: true, delimiter: ':', maxListeners: 20)
    @map = Immutable.Map()

  on: (event, fn) -> @eventEmitter.on(event, fn)
  off: (event, fn) -> @eventEmitter.off(event, fn)
  emit: (event, payload) -> @eventEmitter.emit(event, payload)

  toArray: -> @map.toArray()
  filter: (opts) -> @map.filter(opts)
  where: (query) -> filter(@map)(query)
  sort: (opts) -> @map.sort(opts)
  sortBy: (opts) -> @map.sortBy(opts)
  forEach: (fn) -> @map.forEach(fn)

  get: (id) -> @map.get(id)

  set: (id, newObj) ->
    newMap = @map.set(id, newObj)
    unless Immutable.is(@map, newMap)
      @map = newMap
      @emit("inject", newObj)
      @emit("change")
      newObj

  unset: (id) ->
    obj = @map.get(id)
    newMap = @map.delete(id)
    unless Immutable.is(@map, newMap)
      @emit("eject", obj)
      @emit("change")
      obj

  inject: (newObj) ->
    if Object.isObject(newObj)
      throw new Error("missing primary key") unless newObj[@identityKey]?
      @set(newObj[@identityKey], newObj)
    else
      throw new Error("unexpected argument")

  eject: (obj) ->
    if Object.isObject(obj)
      throw new Error("missing primary key") unless obj[@identityKey]?
      @unset(obj[@identityKey])
    else
      @unset(obj)

  ejectAll: ->
    @map.forEach(@eject)

module.exports = Store

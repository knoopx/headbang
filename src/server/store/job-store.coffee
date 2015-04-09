Events = require("./../service/events")

store = require("./../store")()

store.on "inject", (obj) ->
  Events.emit("inject:job", obj)


store.on "eject", (obj) ->
  Events.emit("eject:job", obj.id)

module.exports = store

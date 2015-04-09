Events = require("./../service/events")

store = require("./../store")()

store.on "inject", (obj) ->
  Events.emit("inject:track", obj)

store.on "eject", (obj) ->
  Events.emit("eject:track", obj.id)

module.exports = store

FS = require("fs")
Path = require("path")
Events = require("./../service/events")
TrackStore = require("./track-store")
store = require("./../store")()

store.on "inject", (obj) ->
  Events.emit("inject:album", obj)
  data = Object.merge(tracks: TrackStore.toArray().filter(albumId: obj.id), obj)
  indexPath = Path.join(obj.path, ".headbang")
  FS.writeFileSync(indexPath, JSON.stringify(data))

store.on "eject", (obj) ->
  Events.emit("eject:album", obj.id)

module.exports = store

FS = require("fs")
Path = require("path")
TrackStore = require("./track-store")
Store = require("./../../common/store")
store = new Store()

store.on "inject", (obj) ->
  data = Object.merge(tracks: TrackStore.toArray().filter(albumId: obj.id), obj)
  indexPath = Path.join(obj.path, ".headbang")
  FS.writeFileSync(indexPath, JSON.stringify(data))

module.exports = store

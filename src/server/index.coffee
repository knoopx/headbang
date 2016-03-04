Server = require('http').Server(require("./router"))
Album = require("./model/album")
AlbumStore = require("./store/album-store")
TrackStore = require("./store/track-store")

IO = require('socket.io')(Server)

IO.on 'connection', (socket) ->
  AlbumStore.on "inject", (obj) ->
    Album.dump(obj)
    socket.emit("inject:album", obj)

  AlbumStore.on "eject", (obj) -> socket.emit("eject:album", obj.id)
  TrackStore.on "inject", (obj) -> socket.emit("inject:track", obj)
  TrackStore.on "eject", (obj) -> socket.emit("eject:track", obj.id)

module.exports = Server

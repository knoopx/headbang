events = require("./events")
AlbumStore = require("./store")("/albums")
events.pipe("album", AlbumStore)

module.exports = AlbumStore

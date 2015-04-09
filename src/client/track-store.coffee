events = require("./events")
TrackStore = require("./store")("/tracks")
events.pipe("track", TrackStore)

module.exports = TrackStore

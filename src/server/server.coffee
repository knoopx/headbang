Server = require('http').Server(require("./router"))
Events = require("./service/events")

IO = require('socket.io')(Server)

IO.on 'connection', (socket) ->
  Events.onAny (payload) ->
    socket.emit(@event, payload)

module.exports = Server

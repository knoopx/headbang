io = require("socket.io-client")()

module.exports =
  io: io
  pipe: (name, store) ->
    io.on "inject:#{name}", (data) ->
      store.inject(data)

    io.on "eject:#{name}", (data) ->
      store.eject(data)

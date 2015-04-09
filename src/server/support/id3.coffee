Q = require("q")
mm = require('musicmetadata')
FS = require("fs")

FileQueue = require("filequeue")
FQ = new FileQueue(4)

module.exports =
  fromFile: (file) ->
    @fromStream(FQ.createReadStream(file))

  fromStream: (stream) ->
    defer = Q.defer()
    parser = mm stream, (err, meta) ->
      stream.destroy()
      if err
      then defer.reject(new Error(err))
      else defer.resolve(meta)

    parser.on "done", -> stream.destroy()
    defer.promise

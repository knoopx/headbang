Q = require("q")
mm = require('musicmetadata')

FileQueue = require("filequeue")
FQ = require("./service/fq")

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

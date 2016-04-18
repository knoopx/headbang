Q = require("q")
mm = require('musicmetadata')

FileQueue = require("filequeue")
FQ = require("./service/fq")

module.exports =
  fromFile: (file) ->
    @fromStream(FQ.createReadStream(file))

  fromStream: (stream) ->
    Q.promise (resolve, reject) ->
      parser = mm stream, (err, meta) ->
        stream.destroy()
        if err
        then reject(new Error(err))
        else resolve(meta)

      parser.on "done", -> stream.destroy()

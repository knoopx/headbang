Path = require("path")
FS = require("fs")
Q = require("q")
validate = require("validate.js")

AlbumName = require("./../support/album-name")
AlbumStore = require("./../store/album-store")
Track = require("./track")
TrackStore = require("./../store/track-store")

module.exports =
  validations:
    id: {presence: true}
    name: {presence: true}
    artistName: {presence: true}
    basename: {presence: true}
    path: {presence: true}

  build: (attrs) ->
    defaults =
      artistName: []
      tag: []
      genre: []
      year: []

    attrs = Object.merge(defaults, attrs)
    errors = validate(attrs, @validations)
    throw new Error("Invalid attributes: #{JSON.stringify(errors)}") if errors?
    attrs

  load: (path) ->
    Q.Promise (resolve, reject) ->
      FS.readFile Path.join(path, ".headbang"), (err, data) ->
        return reject(err) if err?
        try
          obj = JSON.parse(data)
          obj.tracks.map (track) -> TrackStore.inject(Track.build(track))
          resolve(AlbumStore.inject(module.exports.build(Object.reject(obj, ["tracks"]))))
        catch e
          reject(e)

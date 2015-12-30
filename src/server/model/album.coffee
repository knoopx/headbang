Path = require("path")
FS = require("fs")
Q = require("q")
validate = require("validate.js")

AlbumName = require("./../support/album-name")
AlbumStore = require("./../store/album-store")
Track = require("./track")
TrackStore = require("./../store/track-store")
Support = require("../../common/support")

module.exports =
  validations:
    id: {presence: true}
    name: {presence: true}
    artistName: {presence: true}
    basename: {presence: true}
    path: {presence: true}

  build: (props) ->
    props = @parse(props)
    errors = validate(props, @validations)
    throw new Error("Invalid attributes: #{JSON.stringify(errors)}") if errors?
    props

  parse: (props = {}) ->
    rules =
      id: Support.parseString
      name: Support.parseString
      basename: Support.parseString
      path: Support.parseString
      artwork: Support.parseString
      artistName: Support.parseStringArray
      genre: Support.parseStringArray
      tag: Support.parseStringArray
      year: Support.parseStringArray
      starred: Support.parseBool
      indexedAt: (value) -> Support.parseInt(value) || Date.now()

    obj = {}
    Object.keys(rules).each (propName) ->
      result = rules[propName](props[propName])
      obj[propName] = result if result?
    obj

  merge: (a, b) ->
    b = @parse(b)
    mergeUniqueValues = (a, b) => Support.wrapArray(a).concat(b).unique()
    replaceIfSourceIsEmpty = (a, b) -> if Support.isEmpty(a) then b else a
    replaceUnlessTargetIsEmpty = (a, b) -> if Support.isEmpty(b) then a else b

    rules =
      name: replaceUnlessTargetIsEmpty
      artwork: replaceIfSourceIsEmpty
      artistName: replaceUnlessTargetIsEmpty
      genre: mergeUniqueValues
      tag: mergeUniqueValues
      year: mergeUniqueValues

    obj = Object.clone(a)
    Object.keys(rules).each (propName) ->
      result = rules[propName](a[propName], b[propName])
      obj[propName] = result
    obj

  dump: (obj) ->
    throw new Error("Unexpected argument") unless obj.id? and obj.path?
    path = Path.join(obj.path, ".headbang")
    FS.writeFileSync(path, JSON.stringify(Object.merge(tracks: TrackStore.toArray().filter(albumId: obj.id), obj)))

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

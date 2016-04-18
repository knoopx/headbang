Path = require("path")
Q = require("q")
validate = require("validate.js")

FQ = require("../service/fq")

AlbumStore = require("../store/album-store")
Track = require("./track")
TrackStore = require("../store/track-store")
support = require("../../common/support")
merge = require("../../common/merge")

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
      id: support.parseString
      name: support.parseString
      basename: support.parseString
      path: support.parseString
      artwork: support.parseString
      artistName: support.parseStringArray
      genre: support.parseStringArray
      tag: support.parseStringArray
      label: support.parseStringArray
      country: support.parseStringArray
      year: support.parseStringArray
      starred: support.parseBool
      playCount: (value) -> support.parseInt(value) || 0
      indexedAt: (value) -> support.parseInt(value) || Date.now()
      lastfm: support.parseInt
      discogs: support.parseInt

    obj = {}
    Object.keys(rules).each (propName) ->
      result = rules[propName](props[propName])
      obj[propName] = result if result?
    obj

  merge: (a, b) ->
    merge a, @parse(b),
      name: merge.fn.replaceUnlessTargetIsEmpty
      artwork: merge.fn.replaceIfSourceIsEmpty
      artistName: merge.fn.replaceUnlessTargetIsEmpty
      genre: merge.fn.mergeUniqueValues
      tag: merge.fn.mergeUniqueValues
      label: merge.fn.mergeUniqueValues
      country: merge.fn.mergeUniqueValues
      year: merge.fn.replaceIfSourceIsEmpty
      lastfm: merge.fn.replaceUnlessTargetIsEmpty
      discogs: merge.fn.replaceUnlessTargetIsEmpty
      playCount: merge.fn.replaceUnlessTargetIsEmpty

  dump: (obj) ->
    throw new Error("Unexpected argument") unless obj.id? and obj.path?
    path = Path.join(obj.path, ".headbang")
    require("fs").writeFileSync(path, JSON.stringify(support.merge(tracks: TrackStore.where(albumId: obj.id).toArray(), obj)))

  load: (path) ->
    Q.Promise (resolve, reject) ->
      FQ.readFile Path.join(path, ".headbang"), (err, data) ->
        return reject(err) if err?
        try
          obj = JSON.parse(data)
          obj.tracks.map (track) -> TrackStore.inject(Track.build(track))
          resolve(AlbumStore.inject(module.exports.build(Object.reject(obj, ["tracks"]))))
        catch e
          reject(e)

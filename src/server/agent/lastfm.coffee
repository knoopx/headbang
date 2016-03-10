Q = require("q")
Axios = require("axios")
rateLimit = require('timetrickle')(10, 1000)

support = require("../../common/support")

parseArray = (value) -> if Array.isArray(value) then value || [] else []

module.exports = (apiKey) ->
  lookup: (album, force = false) ->
    return Q.reject(new Error("album has no name")) unless album.name?
    return Q.reject(new Error("already looked up on lastfm")) if album.lastfm? and not force

    query =
      method: "album.getinfo"
      album: support.querify(album.name)
      artist: support.querify(album.artistName[0])
      autocorrect: "1"
      api_key: apiKey
      format: "json"

    @performRequest(query).then (response) ->
      if match = response.album
        tagNames = match.tags.tag.map("name")
        name: support.normalizeAlbumName(match.name)
        artistName: support.normalizeArtistName(match.artist)
        year: support.parseYear(match.wiki?.published) || tagNames.map(support.parseYear).unique()
        artwork: match.image[match.image.length - 1]["#text"]
        genre: tagNames.map(support.parseGenre).compact().unique()
        lastfm: Date.now()
      else
        Q.reject(new Error("no match: #{JSON.stringify(Object.select(query, ['artist', 'album']))}"))

  performRequest: (query) ->
    defer = Q.defer()
    rateLimit ->
      Axios.get("http://ws.audioscrobbler.com/2.0/", params: query).then (response) ->
        defer.resolve(response.data)
      , defer.reject

    defer.promise

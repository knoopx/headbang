Q = require("q")
Axios = require("axios")
rateLimit = require('timetrickle')(10, 1000)

Genre = require("./../model/genre")
Job = require("../model/job")
JobStore = require("../store/job-store")
Support = require("../../common/support")

parseArray = (value) -> if Array.isArray(value) then value || [] else []

module.exports = (apiKey) ->
  lookup: (album, force = false) ->
    return Q.reject(new Error("album has no name")) unless album.name?
    return Q.reject(new Error("already looked up on lastfm")) if album.lastfm? and not force

    query =
      method: "album.getinfo"
      album: Support.querify(album.name)
      artist: Support.querify(album.artistName[0])
      autocorrect: "1"
      api_key: apiKey
      format: "json"

    @performRequest(query).then (response) ->
      if match = response.album
        tagNames = match.tags.tag.map("name")
        name: Support.normalizeAlbumName(match.name)
        artistName: Support.normalizeArtistName(match.artist)
        year: Support.parseYear(match.wiki?.published) || tagNames.map(Support.parseYear).unique()
        artwork: match.image[match.image.length - 1]["#text"]
        genre: tagNames.map(Support.parseGenre).compact().unique()
        lastfm: Date.now()
      else
        Q.reject(new Error("no match: #{JSON.stringify(Object.select(query, ['artist', 'album']))}"))

  performRequest: (query) ->
    defer = Q.defer()
    rateLimit ->
      job = JobStore.inject(Job.build(message: "Looking up on last.fm: #{[query.album, query.artist].compact().join(" - ")}"))

      Axios.get("http://ws.audioscrobbler.com/2.0/", params: query).then (response) ->
        JobStore.eject(job)
        defer.resolve(response.data)
      , defer.reject

    defer.promise

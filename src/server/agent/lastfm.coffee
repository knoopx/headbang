Q = require("q")
Axios = require("axios")
rateLimit = require('timetrickle')(10, 1000)

AlbumName = require("./../support/album-name")
ArtistName = require("./../support/artist-name")
Genre = require("./../model/genre")
Job = require("../model/job")
JobStore = require("../store/job-store")

parseArray = (value) -> if Array.isArray(value) then value || [] else []

module.exports = (apiKey) ->
  performRequest = (query) ->
    defer = Q.defer()
    rateLimit ->
      job = JobStore.inject(Job.build(message: "Looking up on last.fm: #{[query.album, query.artist].compact().join(" - ")}"))

      Axios.get("http://ws.audioscrobbler.com/2.0/", params: query).then (response) ->
        JobStore.eject(job)
        defer.resolve(response.data)
      , defer.reject

    defer.promise

  lookup: (album, force = false) ->
    return Q.reject(new Error("album has no name")) unless album.name?
    return Q.reject(new Error("already looked up on lastfm")) if album.lastfm? and not force

    query =
      method: "album.getinfo"
      album: AlbumName.querify(album.name)
      autocorrect: "1"
      api_key: apiKey
      format: "json"

    if album.artistName?.length == 1
      query.artist = ArtistName.querify(album.artistName[0])
    else if album.artistName?.length < 3
      query.artist = album.artistName.map((artist) -> ArtistName.querify(artist)).join(" ")

    performRequest(query).then (response) ->
      if match = response.album
        tagNames = match.tags.tag.map("name")

        year = null
        if match.wiki?.published?
          year = (new Date(match.wiki.published)).getFullYear()
        year ||= tagNames.filter((tag) -> tag.match(/^\d{4}$/)).first()

        name: match.name
        artistName: [match.artist]
        year: year
        artwork: match.image[match.image.length - 1]["#text"]
        genre: Genre.match(tagNames)
        lastfm: Date.now()
      else
        Q.reject(new Error("no match"))

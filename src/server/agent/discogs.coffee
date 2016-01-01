Q = require("q")
Axios = require("axios")
rateLimit = require('timetrickle')(20, 60000)
Genre = require("./../model/genre")
Job = require("../model/job")
JobStore = require("../store/job-store")
TrackStore = require("../store/track-store")
Support = require("../../common/support")
version = require("../../../../package.json").version

module.exports = (apiKey) ->
  headers =
    "User-Agent": "headbang/#{version} +https://github.com/knoopx/headbang"
    "Authorization": "Discogs token=#{apiKey}"

  lookup: (album, force = false) ->
    return Q.reject(new Error("album has no name")) unless album.name?
    return Q.reject(new Error("already looked up on discogs")) if album.discogs? and not force

    query =
      release_title: Support.querify(album.name)
      artist: Support.querify(album.artistName[0])
      format: album.tag.join(" ")
      year: album.year.join(" ")
      type: "release"

    @performRequest(query).then (res) =>
      return Q.reject(new Error("no match: #{JSON.stringify(query)}")) if res.results.length == 0 or res.results.length > 5
      match = res.results[0]
      artwork: match.thumb
      country: [match.country]
      year: [Support.parseYear(match.year)].compact()
      tag: match.format
      genre: (match.genre || []).concat(match.style || []).map(Support.parseGenre).compact().unique()
      label: (match.label || []).map(Support.parseString).compact().map(Support.normalize)
      discogs: Date.now()

  performRequest: (query) ->
    defer = Q.defer()
    rateLimit ->
      job = JobStore.inject(Job.build(message: "Looking up on discogs: #{[query.release_title, query.artist].compact().join(" - ")}"))
      Axios.get("https://api.discogs.com/database/search", params: query, headers: headers)
      .then (res) ->
        JobStore.eject(job)
        defer.resolve(res.data)
      .catch(defer.reject)
    defer.promise

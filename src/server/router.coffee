Express = require('express')
CORS = require('cors')
Morgan = require('morgan')
Path = require("path")
BodyParser = require('body-parser')
Compression = require('compression')

AlbumStore = require("./store/album-store")
JobStore = require("./store/job-store")
TrackStore = require("./store/track-store")

Router = Express()
Router.use Morgan('dev')
Router.use CORS()
Router.use(BodyParser.json())

Router.use Express.static(Path.resolve(__dirname, "../browser"))

Router.patch "/albums/:id", Compression(), (request, response) ->
  if album = AlbumStore.get(request.params.id)
  then response.json(AlbumStore.inject(Object.merge(album, request.body)))
  else response.status(404)

Router.get "/tracks/:id/stream", (request, response) ->
  if track = TrackStore.get(request.params.id)
  then response.sendFile(track.path)
  else response.status(404)

Router.get "/albums", Compression(), (request, response) ->
  response.json(AlbumStore.where(request.query).toArray())

Router.get "/jobs", Compression(), (request, response) ->
  response.json(JobStore.where(request.query).toArray())

Router.get "/tracks", (request, response) ->
  if album = AlbumStore.get(request.query.albumId)
    album.playCount += 1
    AlbumStore.inject(album)

  response.json(TrackStore.where(request.query).toArray())

module.exports = Router

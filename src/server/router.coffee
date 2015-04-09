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

Router.use Express.static(Path.resolve("build"))

Router.get '/', (request, response) ->
  response.sendFile(Path.resolve(__dirname, Path.resolve("src/client/index.html")))

Router.patch "/albums/:id", Compression(), (request, response) ->
  if album = AlbumStore.get(request.params.id)
    response.json(AlbumStore.inject(Object.merge(album, request.body)))
  else response.status(404)

Router.get "/tracks/:id/stream", (request, response) ->
  if track = TrackStore.get(request.params.id)
  then response.sendFile(track.path)
  else response.status(404)

Router.get "/albums", Compression(), (request, response) ->
  response.json(AlbumStore.toArray().filter(request.query))

Router.get "/jobs", Compression(), (request, response) ->
  response.json(JobStore.toArray().filter(request.query))

Router.get "/tracks", (request, response) ->
  response.json(TrackStore.toArray().filter(request.query))

module.exports = Router

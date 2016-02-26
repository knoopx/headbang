require("sugar")
require("source-map-support/register")

q = require("q")
commander = require('commander')
chokidar = require('chokidar')

Server = require("./server")
Scanner = require("./server/service/scanner")
Indexer = require("./server/service/indexer")

FS = require("fs")
Path = require("path")

Album = require("./server/model/album")
AlbumStore = require("./server/store/album-store")
Support = require("./common/support")

scanAndIndex = (path, agents) ->
  Indexer.index(path, commander.force).then (album) ->
    q.all agents.map (agent) ->
      agent.lookup(album, commander.force).then (attrs) ->
        AlbumStore.inject(Album.merge(album, attrs))
  .catch (err) ->
    console.log(err.stack)

removeFromIndex = (path) ->
  AlbumStore.filter((a) -> a.path == path).forEach (album) ->
    AlbumStore.eject(album)

module.exports = commander
.version(require("./package").version)
.option('-f, --force', 'force metadata reload')
.option('--last-fm <key>', 'last.fm api key')
.option('--discogs <key>', 'discogs api key')
.option('-p, --port <n>', 'port number', parseInt, 3366)
.arguments('<path>')
.action (rootPath) ->
  agents = []
  agents.push(require("./server/agent/lastfm")(commander.lastFm)) if commander.lastFm?
  agents.push(require("./server/agent/discogs")(commander.discogs)) if commander.discogs?
  console.log("WARNING: no last.fm (--last-fm) or discogs (--discogs) key specified. no metadata or artwork will be downloaded.") if agents.length == 0

  Server.listen commander.port, ->
    console.log("headbang started on port #{commander.port}")

    chokidar.watch(rootPath)
    .on "ready", ->
      console.log("watching #{rootPath} for changes")
    .on "addDir", (path) ->
      scanAndIndex(path, agents)
    .on "unlinkDir", (path) ->
      removeFromIndex(path)
    .on "raw", (event, path, details) ->
      if event == "moved" && details.type == "directory"
        if FS.existsSync(path)
        then scanAndIndex(path, agents)
        else removeFromIndex(path)

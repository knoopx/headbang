require("sugar")
require("source-map-support/register")

q = require("q")
commander = require('commander')

Server = require("./server")
Scanner = require("./server/service/scanner")
Indexer = require("./server/service/indexer")

FS = require("fs")
Path = require("path")

Album = require("./server/model/album")
AlbumStore = require("./server/store/album-store")
Support = require("./common/support")

module.exports = commander
.version(require("./package").version)
.option('-f, --force', 'force metadata reload')
.option('--last-fm <key>', 'last.fm api key')
.option('--discogs <key>', 'discogs api key')
.option('-p, --port <n>', 'port number', parseInt, 3366)
.arguments('<path>')
.action (rootPath) ->
  agents = []
  queue = require("async").queue ((callback, done) -> callback(done)), 10
  agents.push(require("./server/agent/lastfm")(commander.lastFm)) if commander.lastFm?
  agents.push(require("./server/agent/discogs")(commander.discogs)) if commander.discogs?
  console.log("WARNING: no last.fm (--last-fm) or discogs (--discogs) key specified. no metadata or artwork will be downloaded.") if agents.length == 0

  Server.listen commander.port, ->
    console.log("headbang started on port #{commander.port}")
    console.log("scanning #{rootPath}")
    Scanner.scan rootPath, (path, files) ->
      if files.length > 0
        queue.push (next) ->
          Indexer.index(path, files, commander.force).then (album) ->
            next()
            q.all agents.map (agent) ->
              agent.lookup(album, commander.force).then (attrs) ->
                AlbumStore.inject(Album.merge(album, attrs))

          .catch (err) ->
            console.log(err.stack)
            next()

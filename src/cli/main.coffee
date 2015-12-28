require("sugar")
require("source-map-support/register")

commander = require('commander')

Server = require("./server")
Scanner = require("./server/service/scanner")
Indexer = require("./server/service/indexer")

FS = require("fs")
Path = require("path")

Album = require("./server/model/album")
AlbumStore = require("./server/store/album-store")

module.exports = commander
.version(require("./package").version)
.option('-f, --force', 'force metadata reload')
.option('--last-fm <key>', 'last.fm api key')
.option('-p, --port <n>', 'port number', parseInt, 3366)
.arguments('<path>')
.action (rootPath) ->
  queue = require("async").queue ((callback, done) -> callback(done)), 10
  lastfm = if commander.lastFm? then require("./server/agent/lastfm")(commander.lastFm)
  else console.log("WARNING: no last.fm key specified (--last-fm). no metadata or artwork will be downloaded.")

  Server.listen commander.port, ->
    console.log("headbang started on port #{commander.port}")
    console.log("scanning #{rootPath}")
    Scanner.scan rootPath, (path, files) ->
      if files.length > 0
        queue.push (next) ->
          Indexer.index(path, files, commander.force).then (album) ->
            lastfm?.lookup(album, commander.force).then (attrs) ->
              album.name = attrs.name
              album.artistName = attrs.artistName
              album.artwork = attrs.artwork
              album.lastfm = attrs.lastfm
              ["year", "genre", "tag"].each (attr) ->
                album[attr] = album[attr].concat(attrs[attr]).compact().unique()
              AlbumStore.inject(album)
            next()

          .catch (err) ->
            console.log(err.stack)
            next()

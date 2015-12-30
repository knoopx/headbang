Q = require("q")
Path = require("path")
Mime = require("mime")
Async = require("async")
FS = require("fs")
Scanner = require("./scanner")
Genre = require("./../model/genre")

Job = require("./../model/job")
JobStore = require("./../store/job-store")
Album = require("./../model/album")
AlbumStore = require("./../store/album-store")
Track = require("./../model/track")
TrackStore = require("./../store/track-store")
ID3 = require("./../support/id3")
AlbumName = require("./../support/album-name")
MD5 = require("crypto/md5")
Support = require("../../common/support")

readID3 = (tracks) ->
  Q.all(tracks.map (track) -> ID3.fromFile(track))

indexAlbum = (path, files, prevAlbum) ->
  AlbumStore.eject(prevAlbum.id) if prevAlbum?.id?

  stat = FS.statSync(path)
  basename = Path.basename(path)

  readID3(files.sort()).then (id3) ->
    data =
      id: MD5.hex_md5(path).to(10)
      name: AlbumName.strip(id3.map("album").unique().first()) # todo: handle directories with multiple albums
      artistName: id3.map("artist").flatten()
      genre: id3.map("genre").flatten().map(Support.parseGenre).compact().unique()
      tag: AlbumName.tags(basename)
      year: id3.map("year").flatten()
      basename: basename
      path: path
      indexedAt: stat.birthtime || stat.ctime

    if prevAlbum?
      data = Object.merge(prevAlbum, data)

    album = Album.build(data)

    for file, index in files.sort()
      basename = Path.basename(file)
      artistName = id3[index].albumartist
      artistName = id3[index].artist unless artistName.length > 0
      TrackStore.inject Track.build
        id: MD5.hex_md5(file).to(10)
        number: id3[index].track?.no || index
        name: id3[index].title
        artistName: [id3[index].artist || id3[index].albumartist].compact().unique()
        basename: basename
        path: file
        albumId: album.id

    AlbumStore.inject(album)

module.exports =
  isFileIndexable: (file) ->
    ["audio/mpeg"].indexOf(Mime.lookup(file)) >= 0

  index: (path, files, force = false) ->
    job = JobStore.inject(Job.build(message: "Indexing #{path}"))
    Album.load(path).then (album) ->
      if force
      then indexAlbum(path, files, album)
      else album
    .catch -> indexAlbum(path, files)
    .fin ->
      JobStore.eject(job)

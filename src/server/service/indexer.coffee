Q = require("q")
Path = require("path")
Mime = require("mime")
MD5 = require("crypto/md5")

FQ = require("../service/fq")

Album = require("../model/album")
AlbumStore = require("../store/album-store")
Track = require("../model/track")
TrackStore = require("../store/track-store")
ID3 = require("../id3")
support = require("../../common/support")

readdir = (path) -> Q.nfcall(FQ.readdir.bind(FQ), path)
stat = (file) -> Q.nfcall(FQ.stat.bind(FQ), file)
readID3 = (tracks) -> Q.all(tracks.map (track) -> ID3.fromFile(track))
isFileIndexable = (file) -> ["audio/mpeg"].indexOf(Mime.lookup(file)) >= 0

indexAlbum = (path, prevAlbum) ->
  path = Path.resolve(path)
  Q.nfcall(FQ.stat.bind(FQ), path).then (stat) ->
    basename = Path.basename(path)

    readdir(path).then (files) ->
      files = files.filter(isFileIndexable).sort().map((f) -> Path.resolve(path, f))
      if files.length > 0
        readID3(files).then (id3) ->
          data =
            id: MD5.hex_md5(path).to(10)
            name: support.normalizeAlbumName(id3.map("album").unique().first()) # todo: handle directories with multiple albums
            artistName: id3.map("artist").flatten().unique().map(support.normalizeArtistName).flatten().unique()
            genre: id3.map("genre").flatten().map(support.parseGenre).compact().unique()
            tag: support.parseAlbumTags(basename)
            year: id3.map("year").flatten()
            basename: basename
            path: path
            indexedAt: (stat.birthtime || stat.ctime).getTime()

          if prevAlbum?
            AlbumStore.eject(prevAlbum)
            data = support.merge(prevAlbum, data)

          album = Album.build(data)

          for file, index in files.sort()
            TrackStore.inject Track.build
              id: MD5.hex_md5(file).to(10)
              number: id3[index].track?.no || index
              name: id3[index].title
              artistName: id3[index].artist.map(support.normalizeArtistName).flatten().unique()
              basename: Path.basename(file)
              path: file
              albumId: album.id

          AlbumStore.inject(album)
      else
        throw new Error("No indexable files found")


module.exports =
  index: (path, force = false) ->
    Album.load(path).then (album) ->
      AlbumStore.inject(album)
      if force
      then indexAlbum(path, album)
      else album
    .catch -> indexAlbum(path)

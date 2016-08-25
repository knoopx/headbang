import Path from 'path'
import Mime from 'mime'
import FS from 'fs'
import is from 'is_js'
import {flow, castArray, flatMap, flatten, map, filter, reject, last, sortedUniq} from 'lodash/fp'
import {autobind} from 'core-decorators'

import ID3 from './id3'
import queues from './queues'
import {queue, job} from './queueing'

import Album from './album'
import Track from './track'

import {shortId} from './support'
import normalize from './normalize'

@autobind
export default class Indexer {
  constructor(agents = []){
    this.agents = agents
  }

  @queue(queues.index)
  @job((path) => `Indexing ${path}`)
  async index(path) {
    const file = Path.join(path, '.headbang')

    if (FS.existsSync(file)) {
      const album = Album.load(file)
      this.lookupAlbum(album)
      return album
    }

    return this.indexAndLookupAlbum(path)
  }

  async readID3(tracks: Array<any>) {
    return Promise.all(tracks.map(track => ID3.fromFile(track)))
  }

  parseTags(tags: Array<any>){
    return {
      name: flow(flatMap('album'), map(normalize.albumName), filter(is.string), sortedUniq, last)(tags),
      artistName: flow(flatMap('artist'), map(normalize.artistName), filter(is.string), sortedUniq)(tags),
      genre: flow(flatMap('genre'), map(normalize.genre), flatten, filter(is.string), sortedUniq)(tags),
      year: flow(flatMap('year'), map(parseInt), filter(is.number), sortedUniq)(tags)
    }
  }

  async indexAndLookupAlbum(path: string) {
    const album = await this.indexAlbum(path)
    this.lookupAlbum(album)
    return album
  }

  lookupAlbum(album: Album) {
    this.agents.forEach((agent) => {
      queues.lookup.push(async () => {
        const props = await agent.lookup(album)
        return Album.inject(album.merge(props))
      }).catch(console.log)
    })
  }

  async indexAlbum(_path: string) {
    const path = Path.resolve(_path)
    const basename = Path.basename(path)

    const files = FS.readdirSync(path)
      .filter(this.isFileIndexable)
      .sort()
      .map(f => Path.resolve(path, f))

    if (files.length > 0) {
      const stat = FS.statSync(path)
      const tags = await this.readID3(files)

      const album = new Album({
        id: shortId(path),
        ...this.parseTags(tags),
        tag: normalize.tags(basename),
        isStarred: false,
        indexedAt: (stat.birthtime || stat.ctime).getTime(),
        playCount: 0,
        basename,
        path
      })

      files.sort().map((file, index) => {
        const tag = tags[index]
        Track.inject(new Track({
          id: shortId(file),
          number: tag.track.no || index + 1,
          name: tag.title,
          artistName: flow(castArray, map(normalize.artistName), reject(is.empty))(tag.artist),
          basename: Path.basename(file),
          path: file,
          albumId: album.id
        }))
      })

      return Album.inject(album)
    }

    throw new Error('No indexable files found')
  }

  isFileIndexable(file: string) {
    return ['audio/mpeg'].indexOf(Mime.lookup(file)) >= 0
  }
}

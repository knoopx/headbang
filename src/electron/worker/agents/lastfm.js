import Axios from 'axios'
import is from 'is_js'
import {flow, map, castArray, concat} from 'lodash/fp'

import Album from '../album'
import normalize from '../normalize'
import {RateLimit, queue, job} from '../queueing'

const rateLimit = new RateLimit(10, 1000)

export default class LastFM {
  constructor (apiKey) {
    this.apiKey = apiKey
  }

  async lookup(album: Album, force = false) {
    if (is.empty(album.name)) {
      throw new Error('album has no name')
    }

    if (album.lastfm && !force) {
      throw new Error('already indexed')
    }

    const query = this.buildQuery(album)
    const {data} = await this.performRequest(query)

    if (data.album) {
      return this.parseMatch(data.album)
    }

    throw new Error(`no match: ${JSON.stringify(query.artist, query.album)}`)
  }

  parseMatch(match){

    return {
      name: normalize.albumName(match.name),
      artistName: flow(castArray, map(normalize.artistName))(match.artist),
      year: flow(concat(match.wiki && match.wiki.published), concat(map('name')(match.tags.tag)))([]),
      genre: flow(castArray, map(normalize.genre))(map('name')(match.tags.tag)),
      artwork: match.image[match.image.length - 1]['#text'],
      lastfm: Date.now()
    }
  }

  buildQuery(album){
    const query = {
      method: 'album.getinfo',
      artist: album.artistName[0],
      album: album.name,
      autocorrect: 1,
      api_key: this.apiKey,
      format: 'json'
    }

    return Object.keys(query).reduce((result, key) => {
      if (is.not.empty(query[key])) { result[key] = query[key] }
      return result
    }, {})
  }

  @queue(rateLimit)
  @job((query) => `Looking up ${JSON.stringify(query)} on last.fm`)
  async performRequest(params) {
    return Axios.get('http://ws.audioscrobbler.com/2.0/', {params})
  }
}

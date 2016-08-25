import Axios from 'axios'
import is from 'is_js'
import {flow, map, concat, reject, sortedUniq} from 'lodash/fp'

import normalize from '../normalize'
import {version} from '../../../../package.json'
import {RateLimit, queue, job} from '../queueing'

const rateLimit = new RateLimit(20, 60000)

export default class Discogs {
  constructor(apiKey) {
    this.headers = {
      'User-Agent': `headbang/${version} +https://github.com/knoopx/headbang`,
      Authorization: `Discogs token=${apiKey}`
    }
  }

  async lookup(album, force = false) {
    if (is.empty(album.name)) {
      throw new Error('album has no name')
    }

    if (album.discogs && !force) {
      throw new Error('already indexed')
    }

    const query = this.buildQuery(album)
    const {data} = await this.performRequest(query)

    if (data.results.length === 0 || data.results.length > 2) {
      throw new Error(`no match: ${JSON.stringify(query)}`)
    }

    return this.parse(data.results[0])
  }

  parse(match){
    return {
      artwork: match.thumb,
      country: match.country,
      year: match.year,
      tag: match.format,
      genre: flow(concat(match.genre), concat(match.style), map(normalize.genre), reject(is.empty), sortedUniq)([]),
      label: flow(map(normalize.string), reject(is.empty), sortedUniq)(match.labels),
      discogs: Date.now()
    }
  }

  buildQuery(album) {
    const query = {
      release_title: album.name,
      artist: album.artistName[0],
      format: album.tag.join(' '),
      year: album.year[0],
      type: 'release'
    }

    return Object.keys(query).reduce((result, key) => {
      if (is.not.empty(query[key])) { result[key] = query[key] }
      return result
    }, {})
  }

  @queue(rateLimit)
  @job((query) => `Looking up ${JSON.stringify(query)} on discogs.com`)
  async performRequest(params) {
    return Axios.get('https://api.discogs.com/database/search', {params, headers: this.headers})
  }
}

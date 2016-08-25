import FS from 'fs'
import is from 'is_js'

import Track from './track'
import Model from './model'

import {flow, castArray, flatten, sortedUniq, filter, reject, first, last} from 'lodash/fp'

export default class Album extends Model {
  id: string
  name: string
  basename: string
  path: string
  artwork: ?string
  artistName: Array<string>
  genre: Array<string>
  tag: Array<string>
  label: Array<string>
  country: Array<string>
  year: Array<number>
  isStarred: bool
  playCount: number
  indexedAt: number
  lastfm: ?number
  discogs: ?number

  constructor(props: Object) {
    super({
      artistName: [],
      genre: [],
      tag: [],
      label: [],
      country: [],
      year: [],
      ...props
    })
  }

  static mergeRules = {
    name: flow(filter(is.string), reject(is.empty), last),
    artwork: flow(filter(is.string), reject(is.empty), last),
    artistName: flow(filter(is.array), reject(is.empty), last, sortedUniq),
    genre: flow(flatten, filter(is.string), reject(is.empty), sortedUniq),
    tag: flow(flatten, filter(is.string), reject(is.empty), sortedUniq),
    label: flow(flatten, filter(is.string), reject(is.empty), sortedUniq),
    country: flow(flatten, filter(is.string), reject(is.empty), sortedUniq),
    year: flow(flatten, reject(is.not.number), first, castArray),
    lastfm: flow(reject(is.not.number), last),
    discogs: flow(reject(is.not.number), last),
    playCount: flow(reject(is.not.number), last)
  }

  static load(path: string) {
    const data = FS.readFileSync(path)
    const {tracks, ...album} = JSON.parse(data)
    tracks.map(track => Track.inject(new Track(track)))
    return this.inject(new Album(album))
  }
}

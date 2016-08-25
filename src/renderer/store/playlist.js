import {autobind} from 'core-decorators'
import {observable, computed} from 'mobx'
import {client} from '../store'
import Storage from '../support/storage'

@autobind
class Playlist {
  audio = new Audio()

  @observable isPlaying = false
  @observable currentTime = 0
  @observable duration = 0
  @observable items = Storage.get('playlist:items', [])
  @observable activeIndex = Storage.get('playlist:index', 0)

  @computed get activeItem() {
    if (this.activeIndex >= 0 && this.activeIndex < this.items.length) {
      return this.items[this.activeIndex]
    }
  }

  constructor() {
    this.audio.addEventListener('loadeddata', this.onDataLoaded)
    this.audio.addEventListener('timeupdate', this.onTimeUpdate)
    this.audio.addEventListener('play', this.onPlay)
    this.audio.addEventListener('pause', this.onPause)
    this.audio.addEventListener('ended', this.onEnded)
  }

  onDataLoaded() {
    this.duration = this.audio.duration
  }

  onTimeUpdate() {
    this.currentTime = this.audio.currentTime
  }

  onEnded() {
    this.playNext()
  }

  onPlay() {
    this.isPlaying = true
  }

  onPause() {
    this.isPlaying = false
  }

  relativeItem(offset) {
    const nextIndex = this.activeIndex + offset
    if (nextIndex >= 0 && nextIndex < this.items.length) {
      return this.items[nextIndex]
    }
  }

  playItem(item) {
    this.pause()
    this.load(`${client.tracks.endpoint}/${item.track.id}/stream`)
    this.resume()
    this.activeIndex = this.items.indexOf(item)
  }

  playNext() {
    const item = this.relativeItem(1)
    if (item) {
      return this.playItem(item)
    }
  }

  playPrev() {
    const item = this.relativeItem(-1)
    if (item) {
      return this.playItem(item)
    }
  }

  resume() {
    if (this.items.length > 0) {
      this.audio.play()
    }
  }

  pause() {
    this.audio.pause()
  }

  playOrPause() {
    if (this.isPlaying) {
      this.pause()
    } else {
      this.resume()
    }
  }

  seekTo(value) {
    this.audio.currentTime = value
  }

  load(src) {
    this.audio.src = src
  }

  replace(items) {
    this.activeIndex = 0
    this.items.replace(items)
  }

  append(items) {
    this.items.concat(items)
  }
}

export default new Playlist()

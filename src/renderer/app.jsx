import React from 'react'
import firstBy from 'thenby'
import {observable, computed, toJS} from 'mobx'
import {observer} from 'mobx-react'
import {autobind, mixin} from 'core-decorators'

import {Row, Column, Divider} from './layout'
import Toolbar from './toolbar'
import AlbumList from './album-list'
import PlayList from './play-list'
import NowPlaying from './now-playing'
import Spinner from './spinner'

import Storage from './support/storage'
import {client, albums} from './store'
import KeyBindings from './mixins/key-bindings'

import playlist from './store/playlist'

@autobind
@observer
@mixin(KeyBindings)
export default class App extends React.Component {
  @observable isConnected = false
  @observable filter = Storage.get('filter', {
    query: '',
    predicates: {},
    isStarred: null,
    order: 'ascending'
  })

  orderFn = {
    ascending: firstBy(a => a.artistName.length)
      .thenBy(a => (a.artistName || []).sort()[0].toLocaleLowerCase())
      .thenBy('year')
      .thenBy(a => a.name.toLocaleLowerCase())
      .thenBy('id'),
    recent: firstBy('indexedAt', -1).thenBy('id'),
    playCount: firstBy('playCount', -1).thenBy('id')
  }

  @computed get matches() {
    const {query, predicates, isStarred, order} = this.filter
    const _predicates = toJS(predicates)
    const filter = {
      name: new RegExp(query, 'i'),
      isStarred,
      ...Object.keys(_predicates).reduce((obj, key) => {
        obj[key] = new RegExp(obj[key], 'i')
        return obj
      }, _predicates)
    }

    return albums.where(filter).sort(this.orderFn[order])
  }

  componentWillMount() {
    client.socket.on('connect', this.handleConnect)
    client.socket.on('disconnect', this.handleDisconnect)
  }

  render() {
    if (this.isConnected) {
      return (
        <Column flex={1} style={{overflow: 'hidden'}}>
          <Toolbar filter={this.filter} albumCount={this.matches.length} onChangeFilter={this.handleFilterChange} />
          <Divider direction="horizontal" />
          <Row flex={1}>
            <Column flex={1}>
              <AlbumList ref="albumList" albums={this.matches} onSelect={this.handleAlbumSelected} />
            </Column>
            <Divider direction="vertical" />
            <Column flex={1}>
              {playlist.activeItem && <Row><NowPlaying item={playlist.activeItem} /></Row>}
              {playlist.activeItem && <Divider direction="horizontal" />}
              <Row flex={1}>
                <PlayList ref="playlist" onSelect={this.handlePlaylistItemSelected} />
              </Row>
            </Column>
          </Row>
        </Column>
      )
    }

    return (
      <Column flex={1} style={{alignItems: 'center'}}>
        <Row flex={1} style={{alignItems: 'center'}}>
          <Spinner size={128} />
        </Row>
      </Column>
    )
  }

  handleConnect() {
    this.isConnected = true
  }

  handleDisconnect() {
    this.isConnected = false
  }

  handleFilterChange(filter) {
    Storage.set('filter', filter)
    this.filter = filter
    this.refs.albumList.scrollToTop()
  }

  async handleAlbumSelected(album, e) {
    const shouldClearPlaylist = !e.shiftKey
    const tracks = await client.tracks.findAll({albumId: album.id})
    const items = tracks.sort(firstBy('number')).map(track => ({track, album}))

    if (shouldClearPlaylist) {
      playlist.replace(items)
      playlist.playItem(items[0])
    } else {
      playlist.append(items)
    }
  }

  handlePlaylistItemSelected(item) {
    playlist.playItem(item)
  }
}

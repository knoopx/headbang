import React from 'react'
import {autobind, mixin} from 'core-decorators'
import {observer} from 'mobx-react'

import playlist from './store/playlist'
import {Row, Column, Gutter} from './layout'
import KeyBindings from './mixins/key-bindings'
import SeekBar from './seek-bar'
import PlaybackButtons from './playback-buttons'

@autobind
@observer
@mixin(KeyBindings)
export default class Player extends React.Component {
  componentDidMount() {
    this.bindKey('space', e => {
      playlist.playOrPause()
      e.preventDefault()
    })

    this.bindKey('shift+right', e => {
      playlist.playNext()
      e.preventDefault()
    })

    this.bindKey('shift+left', e => {
      playlist.playPrev()
      e.preventDefault()
    })
  }

  render() {
    return (
      <Row style={{alignItems: 'center'}}>
        <Column flex={1}>
          <SeekBar onSeek={playlist.seekTo} time={playlist.currentTime} duration={playlist.duration} />
        </Column>
        <Gutter />
        <Column><PlaybackButtons /></Column>
      </Row>
    )
  }
}

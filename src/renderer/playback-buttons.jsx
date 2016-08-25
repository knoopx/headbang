import React from 'react'
import {observer} from 'mobx-react'

import playlist from './store/playlist'
import Button from './button'
import ButtonGroup from './button-group'
import {Column} from './layout'

@observer
export default class PlaybackButtons extends React.Component {
  renderPlayOrPauseIcon() {
    if (playlist.isPlaying) {
      return <i className="fa fa-pause" />
    }
    return <i className="fa fa-play" />
  }

  render() {
    return (
      <Column>
        <ButtonGroup>
          <Button style={{width: 50}} onClick={playlist.playPrev}>
            <i className="fa fa-backward" tabIndex="-1" />
          </Button>
          <Button style={{width: 50}} onClick={playlist.playOrPause} tabIndex="-1">
            {this.renderPlayOrPauseIcon()}
          </Button>
          <Button style={{width: 50}} onClick={playlist.playNext} tabIndex="-1">
            <i className="fa fa-forward" />
          </Button>
        </ButtonGroup>
      </Column>
    )
  }
}

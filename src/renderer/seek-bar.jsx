import React from 'react'
import {autobind} from 'core-decorators'

import {Row, Gutter} from './layout'
import format from './support/format'
import styles from './seek-bar.scss'

@autobind
export default class SeekBar extends React.Component {
  static propTypes = {
    time: React.PropTypes.number.isRequired,
    duration: React.PropTypes.number.isRequired,
    onSeek: React.PropTypes.func.isRequired
  }

  handleSeek(e) {
    this.props.onSeek(e.target.value)
  }

  render() {
    const {time, duration} = this.props
    return (
      <Row flex={1}>
        <span className="time">{format.duration(time)}</span>
        <Gutter />
        <input className={styles.input} max={duration} min={0} value={time} onChange={this.handleSeek} type="range" tabIndex="-1" />
        <Gutter />
        <span className="duration">{format.duration(duration)}</span>
      </Row>
    )
  }
}

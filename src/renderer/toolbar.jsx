import React from 'react'
import styles from './toolbar.scss'

import playlist from './store/playlist'

import Player from './player'
import FilterGroup from './filter-group'
import {Row, Column, Gutter} from './layout'

export default class Toolbar extends React.Component {
  static propTypes = {
    filter: React.PropTypes.object.isRequired,
    albumCount: React.PropTypes.number.isRequired,
    onChangeFilter: React.PropTypes.func.isRequired
  }

  render() {
    return (
      <Row className={styles.toolbar}>
        <Column flex={1}>
          <FilterGroup filter={this.props.filter} albumCount={this.props.albumCount} onChange={this.props.onChangeFilter} />
        </Column>

        <Gutter />

        <Column flex={1}>
          <Player onClickPlayPrev={playlist.playPrev} onClickPlayNext={playlist.playNext} />
        </Column>
      </Row>
    )
  }
}

import React from 'react'
import {autobind} from 'core-decorators'

import ListItem from './list-item'
import {Gutter} from './layout'

import styles from './list-item.scss'

@autobind
export default class PlayListItem extends React.Component {
  onSelect() {
    return this.props.onSelect(this.props.item)
  }

  render() {
    const {style, item, ...extraProps} = this.props
    const {track, album} = item
    return (
      <ListItem {...extraProps} style={{display: 'flex', ...style}} active={extraProps.active} onClick={this.onSelect}>
        <strong>{track.name}</strong>
        <Gutter />
        <span className={styles.textMuted}>{track.artistName.join(', ')}</span>
      </ListItem>
    )
  }
}

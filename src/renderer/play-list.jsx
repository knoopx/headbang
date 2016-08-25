
import React from 'react'
import {observable} from 'mobx'
import {observer} from 'mobx-react'
import {autobind} from 'core-decorators'

import VirtualList from './virtual-list'
import PlayListItem from './play-list-item'

import playlist from './store/playlist'

@observer
@autobind
export default class PlayList extends React.Component {
  static propTypes = {
    itemHeight: React.PropTypes.number.isRequired,
    onSelect: React.PropTypes.func.isRequired,
  }

  static defaultProps = {
    itemHeight: 37,
  }

  @observable itemHeight = this.props.itemHeight

  renderItem(item, index) {
    return (
      <PlayListItem key={index} active={playlist.activeItem === item} item={item} onSelect={this.props.onSelect} style={{height: this.itemHeight}} />
    )
  }

  render() {
    return (
      <VirtualList ref="virtualList" items={playlist.items} renderItem={this.renderItem} itemHeight={this.itemHeight} />
    )
  }
}

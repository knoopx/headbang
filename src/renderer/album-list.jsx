import React from 'react'
import {propTypes, observer} from 'mobx-react'
import {autobind} from 'core-decorators'
import VirtualList from './virtual-list'
import AlbumListItem from './album-list-item'

@autobind
@observer
export default class AlbumList extends React.Component {
  static propTypes = {
    albums: propTypes.arrayOrObservableArray.isRequired,
    onSelect: React.PropTypes.func.isRequired,
    itemHeight: React.PropTypes.number.isRequired
  }

  static defaultProps = {
    itemHeight: 57
  }

  scrollToTop() {
    if (this.refs.virtualList) {
      this.refs.virtualList.scrollToTop()
    }
  }

  renderItem(album) {
    return (
      <AlbumListItem key={album.id} album={album} onSelect={this.props.onSelect} style={{height: this.props.itemHeight}} />
    )
  }

  renderItemAtIndex({index}) {
    return this.renderItem(this.props.albums[index])
  }

  render() {
    return (
      <VirtualList ref="virtualList" items={this.props.albums} renderItem={this.renderItem} itemHeight={this.props.itemHeight} />
    )
  }
}

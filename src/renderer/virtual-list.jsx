import React from 'react'
import {propTypes, observer} from 'mobx-react'
import {autobind} from 'core-decorators'
import {observable, computed} from 'mobx'

import styles from './virtual-list.scss'
import listStyles from './list.scss'

@autobind
@observer
export default class VirtualList extends React.Component {
  static propTypes = {
    items: propTypes.arrayOrObservableArray.isRequired,
    itemHeight: React.PropTypes.number.isRequired,
    renderItem: React.PropTypes.func.isRequired
  }

  componentDidMount() {
    window.addEventListener('resize', this.onResize)
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.onResize)
  }

  @observable scrollTop = 0
  @observable clientHeight = 0

  onResize() {
    if (this.container) {
      this.scrollTop = this.container.scrollTop
      this.clientHeight = this.container.clientHeight
    }
  }

  onScroll(e) {
    this.scrollTop = e.target.scrollTop
  }

  setContainer(container) {
    if (container) {
      this.container = container
      this.scrollTop = container.scrollTop
      this.clientHeight = container.clientHeight
    }
  }

  scrollToTop() {
    if (this.container) {
      this.container.scrollTop = 0
    }
  }

  render() {
    const height = this.props.itemHeight * this.props.items.length
    const listViewBox = {
      top: Math.max(0, this.scrollTop),
      bottom: Math.max(0, Math.min(height, this.scrollTop + this.clientHeight))
    }
    const firstItemIndex = Math.max(0, Math.floor(listViewBox.top / this.props.itemHeight))
    const lastItemIndex = Math.ceil(listViewBox.bottom / this.props.itemHeight) - 1
    const offset = firstItemIndex * this.props.itemHeight

    const style = {
      height: height - offset,
      transform: `translateY(${offset}px)`
    }

    return (
      <div className={styles.virtualList} onScroll={this.onScroll}>
        <div ref={this.setContainer} className={styles.virtualListInner}>
          <div className={listStyles.list} style={style}>
            {this.props.items.slice(firstItemIndex, lastItemIndex + 1).map(this.props.renderItem)}
          </div>
        </div>
      </div>
    )
  }
}

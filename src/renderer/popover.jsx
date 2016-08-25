import React from 'react'
import {observable, computed} from 'mobx'
import {observer} from 'mobx-react'
import {autobind} from 'core-decorators'

import styles from './popover.scss'

@autobind
@observer
export default class Popover extends React.Component {
  static popoverCount = 0
  static popoverBaseIndex = 1000

  static propTypes = {
    children: React.PropTypes.any.isRequired,
    popoverContent: React.PropTypes.element.isRequired,
    width: React.PropTypes.number.isRequired,
    height: React.PropTypes.number.isRequired,
    isVisible: React.PropTypes.bool,
    onDismiss: React.PropTypes.func
  }

  static defaultProps = {
    width: 600,
    height: 900
  }

  @observable popoverBounds
  @observable windowBounds

  componentDidMount () {
    ++this.constructor.popoverCount
    this.setWindowBounds()
    window.addEventListener('resize', this.setWindowBounds)
    window.addEventListener('click', this.onWindowClick)
  }

  componentWillUnmount () {
    --this.constructor.popoverCount
    window.removeEventListener('resize', this.setWindowBounds)
    window.removeEventListener('click', this.onWindowClick)
  }

  onWindowClick (event) {
    const {target} = event
    const {containerNode, props} = this
    const {isVisible, onDismiss} = props

    if (containerNode) {
      if (target !== containerNode && !containerNode.contains(target) && isVisible) {
        onDismiss()
      }
    }
  }

  setWindowBounds(){
    const {innerWidth, innerHeight} = window
    this.windowBounds = {
      width: innerWidth,
      height: innerHeight
    }
  }

  setPopoverNode(node) {
    if (node) {
      this.popoverNode = node
    }
  }

  setContainerNode(node) {
    if (node) {
      this.containerNode = node
      this.containerBounds = {
        x: node.offsetLeft,
        y: node.offsetTop,
        width: node.offsetWidth,
        height: node.offsetHeight
      }
    }
  }

  render () {
    const {width, height, isVisible, popoverContent, children, onDismiss, ...extraProps} = this.props
    const zIndex = this.constructor.popoverBaseIndex + this.constructor.popoverCount

    return (
      <div ref={this.setContainerNode} className={styles.container} {...extraProps}>
        {React.Children.only(children)}
        {isVisible && this.containerBounds &&
          <div className={styles.popover} style={{
            zIndex,
            width,
            maxHeight: height,
            left: -(width / 2) + this.containerBounds.width / 2
          }}>
            {popoverContent}
          </div>
        }
      </div>
    )
  }
}

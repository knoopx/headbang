import React from 'react'
import ReactCSSTransitionGroup from 'react-addons-css-transition-group'
import {observable} from 'mobx'
import {observer} from 'mobx-react'
import {queue as Queue} from 'async'

import Spinner from './spinner'
import styles from './artwork.scss'

const queue = Queue((fn, done) => fn(done), 10)

@observer
export default class ArtworkImage extends React.Component {
  static propTypes = {
    src: React.PropTypes.string.isRequired,
    size: React.PropTypes.number.isRequired
  }

  @observable isLoading = true

  componentWillMount() {
    this.setSource(this.props.src)
  }

  componentWilLReceiveProps(props) {
    if (this.props.src !== props.src) {
      this.setSource(props.src)
    }
  }

  setSource(src) {
    queue.unshift(done => {
      const img = new Image()
      img.onload = done
      img.src = src
    }, () => {
      this.isLoading = false
    })
  }

  render() {
    if (this.isLoading) {
      return <Spinner size={Math.round(this.props.size * 0.5)} />
    }

    const style = {
      backgroundImage: `url('${this.props.src}')`,
      width: this.props.size,
      height: this.props.size
    }

    return (
      <ReactCSSTransitionGroup transitionName={{appear: styles.transition, appearActive: styles.transitionActive}} transitionAppear transitionEnterTimeout={0} transitionLeaveTimeout={0} transitionAppearTimeout={0}>
        <div className={styles.artworkImage} style={style} />
      </ReactCSSTransitionGroup>
    )
  }
}

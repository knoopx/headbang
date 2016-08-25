import React from 'react'
import ArtworkImage from './artwork-image'
import styles from './artwork.scss'

export default class Artwork extends React.PureComponent {
  static propTypes = {
    src: React.PropTypes.string,
    size: React.PropTypes.number.isRequired
  }

  static defaultProps = {
    size: 64
  }

  render() {
    return (
      <div className={styles.artwork} style={{width: this.props.size, height: this.props.size}}>
        {this.props.src && this.props.src.length > 0 && <ArtworkImage src={this.props.src} size={this.props.size} />}
      </div>
    )
  }
}

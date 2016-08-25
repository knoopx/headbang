import React from 'react'
import styles from './spinner.scss'

export default class Spinner extends React.Component {
  static propTypes = {
    size: React.PropTypes.number.isRequired,
    color: React.PropTypes.string.isRequired
  }

  static defaultProps = {
    size: 32,
    color: '#ccc'
  }

  render() {
    const {size, color, ...extraProps} = this.props

    return (
      <div className={styles.spinner} style={{width: `${size}px`, height: `${size}px`}} {...extraProps}>
        <div className={styles.bar1} style={{backgroundColor: color}} />
        <div className={styles.bar2} style={{backgroundColor: color}} />
        <div className={styles.bar3} style={{backgroundColor: color}} />
      </div>
    )
  }
}

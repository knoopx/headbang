import React from 'react'

import styles from './tag.scss'

export default class Tag extends React.Component {
  render() {
    return <span className={styles.tag}>{this.props.name}</span>
  }
}

import React from 'react'
import styles from './list.scss'

export default class List extends React.Component {
  render() {
    return (
      <div className={styles.list} {...this.props} />
    )
  }
}

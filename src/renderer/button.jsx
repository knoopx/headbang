import React from 'react'
import styles from './button.scss'

export default class Button extends React.Component {
  render() {
    return <div className={styles.default} {...this.props} />
  }
}

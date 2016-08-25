import React from 'react'
import classNames from 'classnames/bind'

import styles from './list-item.scss'

export default class ListItem extends React.Component {
  render() {
    const {active, ...extraProps} = this.props
    return (
      <div className={classNames.bind(styles)(styles.default, {active})} {...extraProps} />
    )
  }
}

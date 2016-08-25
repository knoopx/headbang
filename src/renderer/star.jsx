import React from 'react'

export default class Star extends React.Component {
  static propTypes = {
    isStarred: React.PropTypes.bool,
    onToggle: React.PropTypes.func.isRequired
  }

  render() {
    const className = this.props.isStarred ? 'fa fa-star' : 'fa fa-star-o'
    return <i className={className} onClick={this.props.onToggle} />
  }
}

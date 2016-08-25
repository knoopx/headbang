import React from 'react'
import {autobind} from 'core-decorators'
import classNames from 'classnames'
import {observable} from 'mobx'
import {propTypes, observer} from 'mobx-react'

import List from './list'
import ListItem from './list-item'
import {Column, Row, Gutter} from './layout'

import styles from './suggestion-list.scss'

@autobind
@observer
export default class SuggestionList extends React.Component {
  static propTypes = {
    suggestions: propTypes.arrayOrObservableArray.isRequired,
    onDismiss: React.PropTypes.func.isRequired,
    onAccept: React.PropTypes.func.isRequired
  }

  static defaultProps = {
    suggestions: []
  }

  @observable activeIndex = 0

  componentWillMount(){
    window.addEventListener('click', this.handleWindowClick)
  }

  componentWillUnMount(){
    window.removeEventListener('click', this.handleWindowClick)
  }

  handleAcceptSuggestion(index) {
    if (index >= 0 && index < this.props.suggestions.length) {
      const suggestion = this.props.suggestions[index]
      if (suggestion) {
        return this.props.onAccept(suggestion)
      }
    }
  }

  handleWindowClick(e) {
    if (this.refs.container && !this.refs.container.contains(e.target)) {
      this.dismiss()
    }
  }

  handleKeyDown(e) {
    switch (e.key) {
      case 'ArrowUp':
        this.selectPrev()
        return e.preventDefault()
      case 'ArrowDown':
        this.selectNext()
        return e.preventDefault()
      case 'Enter':
        this.handleAcceptSuggestion(this.activeIndex)
        return e.preventDefault()
      case 'Escape':
        this.dismiss()
        return e.preventDefault()
    }
  }

  dismiss() {
    this.props.onDismiss()
  }

  selectPrev() {
    if (this.activeIndex > 0) {
      this.activeIndex = this.activeIndex - 1
    } else {
      this.activeIndex = this.suggestions.length - 1
    }
  }

  selectNext() {
    if (this.activeIndex < this.props.suggestions.length - 1) {
      this.activeIndex = this.activeIndex + 1
    } else {
      this.activeIndex = 0
    }
  }

  renderSuggestion(suggestion, index) {
    return (
      <ListItem key={index} active={this.activeIndex === index} onClick={() => { this.handleAcceptSuggestion(index) }}>
        <Row style={{alignItems: 'baseline'}}>
          <Column><strong>{suggestion.value}</strong></Column>
          <Gutter />
          <Column><small className="text-muted">{suggestion.type}</small></Column>
          <Column flex={1} className="text-right"><small>{suggestion.count} album(s)</small></Column>
        </Row>
      </ListItem>
    )
  }

  render() {
    return (
      <div ref="container" className={classNames(styles.suggestionList)}>
        <List>
          {this.props.suggestions.map(this.renderSuggestion)}
        </List>
      </div>
    )
  }
}

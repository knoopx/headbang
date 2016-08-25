import React from 'react'
import {autobind} from 'core-decorators'
import {observer} from 'mobx-react'
import {observable, computed, toJS} from 'mobx'
import {flow, filter, flatten, get, map, matches, sortBy, take} from 'lodash/fp'
import levenshtein from 'fast-levenshtein'

import Popover from './popover'
import {Row, Column, Gutter} from './layout'
import Spinner from './spinner'
import SuggestionList from './suggestion-list'
import JobList from './job-list'

import {albums, jobs} from './store'
import styles from './filter-group.scss'

@autobind
@observer
export default class FilterGroup extends React.Component {
  static propTypes = {
    filter: React.PropTypes.object.isRequired,
    albumCount: React.PropTypes.number.isRequired,
    onChange: React.PropTypes.func.isRequired
  }

  orderKeys = [
    'recent',
    'ascending',
    'playCount'
  ]

  orderClassNames = {
    recent: 'fa fa-clock-o',
    ascending: 'fa fa-sort-alpha-asc',
    playCount: 'fa fa-play'
  }

  predicateKeys = [
    'artistName',
    'genre',
    'label',
    'year',
    'country',
    'tag'
  ]

  @observable suggestions = []
  @observable isPopoverVisible = false

  @computed get suggestionList() {
    const map = this.predicateKeys.reduce((m, predicate) => {
      m[predicate] = new Set()
      return m
    }, {})

    const pairs = albums.reduce((m, album) => {
      Object.keys(m).forEach((predicate) => {
        album[predicate].forEach((value) => {
          m[predicate].add(value.toString().toLocaleLowerCase())
        })
      })
      return m
    }, map)

    return flatten(Object.keys(pairs).map(predicate => (
      [...pairs[predicate].values()].map(value => ({predicate, value}))
    )))
  }

  buildSuggestions(query) {
    return flow(
      filter(s => s.value.indexOf(query) >= 0),
      sortBy(s => levenshtein.get(s.value, query)),
      take(10),
      map(({predicate, value}) => ({predicate, value, count: albums.filter(flow(get(predicate), matches(value))).length}))
    )(this.suggestionList)
  }

  handleAcceptSuggestion({predicate, value}) {
    this.suggestions.clear()
    const {predicates, ...filter} = this.props.filter
    this.props.onChange({...filter, query: '', predicates: {...predicates, [predicate]: value}})
  }

  handleDismissSuggestions() {
    this.suggestions.clear()
  }

  handleKeyDown(e) {
    if (this.refs.suggestions) {
      this.refs.suggestions.handleKeyDown(e)
    }

    const {predicates, ...filter} = this.props.filter

    if (!e.defaultPrevented) {
      switch (e.key) {
        case 'Enter':
          this.onChange({...this.filter, query: e.target.value})
          return e.preventDefault()
        case 'Backspace':
          if (e.target.selectionStart === 0 && e.target.selectionStart === e.target.selectionEnd) {
            this.removePredicate(Object.keys(predicates).pop())
            return e.preventDefault()
          }
      }
    }
  }

  handleQueryChange(e) {
    const query = e.target.value
    this.props.onChange({...this.props.filter, query})

    this.isLoading = true

    if (query && query.length > 1) {
      this.suggestions = this.buildSuggestions(query.toLocaleLowerCase())
      this.isLoading = false
    } else {
      this.suggestions.clear()
      this.isLoading = false
    }
  }

  handleStarredClick() {
    this.props.onChange({...this.props.filter, isStarred: this.props.filter.isStarred ? null : true})
  }

  handleOrderChange() {
    const index = this.orderKeys.indexOf(this.props.filter.order)

    if (index + 1 < this.orderKeys.length) {
      this.props.onChange({...this.props.filter, order: this.orderKeys[index + 1]})
    } else {
      this.props.onChange({...this.props.filter, order: this.orderKeys[0]})
    }
  }

  clearQuery() {
    this.props.onChange({...this.props.filter, query: ''})
  }

  focus() {
    this.query && this.query.focus()
  }

  togglePopover(){
    this.isPopoverVisible = !this.isPopoverVisible
  }

  removePredicate(predicate) {
    const {predicates, ...filter} = this.props.filter
    delete predicates[predicate]
    this.props.onChange({...filter, predicates})
  }

  renderSearchIcon() {
    if (this.isLoading) {
      return <Spinner size={14} />
    }
    return <i className="fa fa-search" />
  }

  renderPopover() {
    return <JobList jobs={jobs.values()} />
  }

  renderPredicate(predicate, value) {
    return (
      <div key={predicate} className={styles.predicate}>
        <span>{predicate}</span>
        <strong>{value}</strong>
        <i className="fa fa-times" onClick={() => { this.removePredicate(predicate) }} />
      </div>
    )
  }

  render() {
    const {query} = this.props.filter

    return (
      <Row style={{alignItems: 'center', margin: '0 80px'}}>
        <Column flex={1}>
          <Row className={styles['filter-group']} style={{alignItems: 'center'}}>
            {this.renderSearchIcon()}
            <Gutter size={6} />
            {Object.keys(this.props.filter.predicates).map((predicate) => this.renderPredicate(predicate, this.props.filter.predicates[predicate]))}
            {Object.keys(this.props.filter.predicates).length > 0 && <Gutter />}
            <input ref={(el) => this.query = el} placeholder="type to filter..." type="text" onKeyDown={this.handleKeyDown} value={query} onChange={this.handleQueryChange} />
            <Gutter />
            <div className="text-right text-muted"><em style={{whiteSpace: 'nowrap'}}>{this.props.albumCount} album(s)</em></div>
            <Gutter />
            <Column>
              <Row>
                {this.props.filter.query.length > 0 && <i className="fa fa-times" onClick={this.clearQuery} />}
                {this.props.filter.query.length > 0 && <Gutter size={8} />}
                <i className={this.orderClassNames[this.props.filter.order]} onClick={this.handleOrderChange} />
                <Gutter size={8} />
                <i className={this.props.filter.isStarred ? 'fa fa-star' : 'fa fa-star-o'} onClick={this.handleStarredClick} />
              </Row>
            </Column>
            {this.suggestions.length > 0 && <SuggestionList ref="suggestions" suggestions={this.suggestions} onAccept={this.handleAcceptSuggestion} onDismiss={this.handleDismissSuggestions} />}
          </Row>
        </Column>

        {jobs.length > 0 && <Gutter />}
        {jobs.length > 0 &&
          <Column style={{display: 'block'}}>
            <Popover
              popoverContent={this.renderPopover()}
              isVisible={this.isPopoverVisible}
              onDismiss={this.togglePopover}
            >
              <Spinner size={16} color="#aaa" onClick={this.togglePopover} />
            </Popover>
          </Column>
        }
      </Row>
    )
  }
}

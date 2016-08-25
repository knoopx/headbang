
import React from 'react'
import {observer, propTypes} from 'mobx-react'
import {autobind} from 'core-decorators'

import VirtualList from './virtual-list'
import ListItem from './list-item'
import {Column, Gutter} from './layout'

import firstBy from 'thenby'

@observer
@autobind
export default class JobList extends React.Component {
  static propTypes = {
    jobs: propTypes.arrayOrObservableArray.isRequired,
    itemHeight: React.PropTypes.number.isRequired
  }

  static defaultProps = {
    itemHeight: 36
  }

  typeIcons = {
    Indexer: 'fa fa-cog',
    LastFM: 'fa fa-lastfm',
    Discogs: 'fa fa-dot-circle-o'
  }

  renderItem(job) {
    return (
      <ListItem key={job.id} style={{height: this.props.itemHeight, alignItems: 'center'}}>
        <i className={this.typeIcons[job.type]} style={{width: 16, textAlign: "center"}} />
        <Gutter />
        <Column flex={1} style={{display: 'block', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'}}>{job.desc}</Column>
      </ListItem>
    )
  }

  render() {
    return (
      <VirtualList style={{display: 'block', overflow: 'auto', zIndex: 100, maxHeight: 600}} items={this.props.jobs.sort(firstBy("date", -1))} renderItem={this.renderItem} itemHeight={this.props.itemHeight} />
    )
  }
}

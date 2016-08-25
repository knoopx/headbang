import React from 'react'
import {autobind} from 'core-decorators'
import {toJS} from 'mobx'
import moment from 'moment'

import is from 'is_js'
import {flow, map, reject, concat, join} from 'lodash/fp'

import {Column, Row, Gutter, Spacer} from './layout'
import ListItem from './list-item'
import Artwork from './artwork'
import Star from './star'
import Tag from './tag'

import {client} from './store'

@autobind
export default class AlbumListItem extends React.Component {
  static propTypes = {
    album: React.PropTypes.object.isRequired,
    onSelect: React.PropTypes.func.isRequired
  }

  toggleIsStarred() {
    client.albums.update(this.props.album.id, {isStarred: !this.props.album.isStarred})
  }

  handleSelect(e) {
    this.props.onSelect(this.props.album, e)
  }

  render() {
    const {album, style, ...extraProps} = this.props
    return (
      <ListItem {...extraProps} style={{display: 'flex', ...style}}>
        <Column style={{alignSelf: 'center', textAlign: 'center'}}>
          <Star isStarred={album.isStarred} onToggle={this.toggleIsStarred} />
        </Column>

        <Gutter />

        <Column onClick={this.handleSelect}>
          <Artwork src={album.artwork} size={40} />
        </Column>

        <Gutter />

        <Column flex={1} onClick={this.handleSelect}>
          <Row style={{alignItems: 'baseline'}}>
            <Column flex="2 0 auto" style={{overflow: 'hidden', display: 'block'}}>
              <Row style={{alignItems: 'center'}} title={album.basename}>
                <Column style={{display: 'block', overflow: 'hidden'}}>
                  <Row><strong>{album.name}</strong></Row>
                </Column>

                {album.tag.length > 0 && <Gutter />}
                <Column style={{overflow: 'hidden'}} >
                  <Row>{album.tag.map(tagName => <Tag key={tagName} name={tagName} />)}</Row>
                </Column>

                <Gutter size={6} />

                <Column style={{overflow: 'hidden'}}>
                  <Row><small className="text-muted">{moment(album.indexedAt).fromNow()}</small></Row>
                </Column>
              </Row>
            </Column>
            <Spacer />
            <Column style={{display: 'block', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'}}>
              <small className="text-muted">{flow(concat(album.year), concat(album.label), map(toJS), reject(is.empty), join(', '))([])}</small>
            </Column>
          </Row>

          <Row style={{alignItems: 'baseline'}}>
            <Column className="text-muted" style={{maxWidth: '90%'}}>
              <Row style={{alignItems: 'center'}}>
                <Column style={{display: 'block', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'}}>{album.artistName.join(', ')}</Column>
                <Gutter size={4} />
                {album.lastfm && <i key="lastfm" className="fa fa-lastfm text-muted" style={{margin: '0 2px'}} title="last.fm" />}
                {album.discogs && <i key="discogs" className="fa fa-dot-circle-o text-muted" style={{margin: '0 2px'}} title="discogs" />}
              </Row>
            </Column>
            <Spacer />
            <Column style={{display: 'block', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'}}>
              <small className="text-muted">{album.genre.join(', ')}</small>
            </Column>
          </Row>
        </Column>
      </ListItem>
    )
  }
}

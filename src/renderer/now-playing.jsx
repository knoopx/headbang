import React from 'react'
import {compact} from 'lodash'

import Artwork from './artwork'
import Tag from './tag'

import {Column, Row, Gutter, Spacer} from './layout'

export default class NowPlaying extends React.Component {
  static propTypes = {
    item: React.PropTypes.object.isRequired,
  }

  render() {
    const {item} = this.props
    const {track, album} = item

    return (
      <Row flex={1} style={{padding: '10px', alignItems: 'center'}}>
        <Column>
          <Artwork src={album.artwork} />
        </Column>

        <Gutter />

        <Column flex={1}>
          <Row style={{alignItems: 'baseline'}}>
            <Column style={{overflow: 'hidden'}} display="block">
              <strong>{track.name}</strong>
            </Column>
            <Spacer />
            <Column style={{overflow: 'hidden'}}>
              <small className="text-muted">{compact([...album.year, ...album.label]).join(', ')}</small>
            </Column>
          </Row>

          <Row style={{alignItems: 'baseline'}}>
            <Column style={{display: 'block', overflow: 'hidden'}}>
              {album.name}
            </Column>
            <Spacer />
            <Column style={{overflow: 'hidden'}}>
              <Row>
                {album.tag.map(tagName => <Tag key={tagName} name={tagName} />)}
              </Row>
            </Column>
          </Row>

          <Row style={{alignItems: 'baseline'}}>
            <Column className="text-muted" style={{display: 'block', overflow: 'hidden'}}>
              {album.artistName.join(', ')}
            </Column>
            <Spacer />
            <Column style={{overflow: 'hidden'}}>
              <small className="text-muted">{album.genre.join(', ')}</small>
            </Column>
          </Row>
        </Column>
      </Row>
    )
  }
}

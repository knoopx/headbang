React = require("react")
Artwork = require("./artwork")
Tag = require("./tag")
{Column, Row, Gutter, Divider} = require("./layout")

module.exports = React.createClass
  displayName: "NowPlaying"
  mixins: [require('react-immutable-render-mixin')]
  propTypes:
    item: React.PropTypes.object.isRequired

  render: ->
    <Row padding="10px">
      <Column flex="initial"><Artwork src={@props.item.album.artwork} /></Column>
      <Gutter/>
      <Column>
        <Row alignItems="baseline">
          <Column overflow="hidden" display="block">
            <strong>{@props.item.track.name}</strong>
          </Column>
          <Gutter/>
          <Column overflow="hidden">
            <small className="text-muted text-right">{([@props.item.album.year].concat(@props.item.album.label).compact().join(', '))}</small>
          </Column>
        </Row>
        <Row alignItems="center">
          <Column overflow="hidden" flex="initial" display="block">{@props.item.album.name}</Column>
          <Gutter/>
            <Column overflow="hidden" flex="initial">
              <Row>{@props.item.album.tag.map((tagName) -> <Tag key={tagName} name={tagName}/>)}</Row>
            </Column>
        </Row>
        <Row alignItems="baseline">
          <Column className="text-muted" overflow="hidden" display="block">{@props.item.album.artistName?.join(", ")}</Column>
          <Gutter/>
          <Column className="text-right" overflow="hidden" flex="initial"><small className="text-muted">{@props.item.album.genre?.join(', ')}</small></Column>
        </Row>
      </Column>
    </Row>

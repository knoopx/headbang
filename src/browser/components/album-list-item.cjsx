React = require("react")
moment = require("moment")

ListItem = require('./list-item')
Artwork = require("./artwork")
Star = require("./star")
Tag = require("./tag")

{Column, Row, Gutter} = require("./layout")

module.exports = React.createClass
  displayName: "AlbumListItem"

  onSelect: ->
    @props.onSelect(@props.album)

  render: ->
    <ListItem key={@props.key}>
      <Column flex="initial" style={{alignSelf:"center"}}><Star album={@props.album} /></Column>

      <Gutter/>

      <Column flex="initial" onDoubleClick={@onSelect}>
        <Row><Artwork src={@props.album.artwork} size={40} /></Row>
      </Column>

      <Gutter/>

      <Column onTouchTap={@onSelect}>
        <Row alignItems="baseline">
          <Column overflow="hidden" display="block">
            <Row alignItems="center" title={@props.album.basename}>
              <Column overflow="hidden" flex="initial" display="block">
                <strong>{@props.album.name}</strong>
              </Column>
              {<Gutter/> if @props.album.tag.length > 0}
              <Column overflow="hidden" flex="initial">
                <Row>{@props.album.tag.map((tagName) -> <Tag key={tagName} name={tagName}/>)}</Row>
              </Column>
              <Gutter size={6}/>
              <Column alignSelf="flex-end">
                <small className="text-muted">{moment(@props.album.indexedAt).fromNow()}</small>
              </Column>
            </Row>
          </Column>

          <Column flex="initial" overflow="hidden" display="block">
            <small className="text-muted text-right">{([@props.album.year].concat(@props.album.labels).compact().join(', '))}</small>
          </Column>
        </Row>

        <Row alignItems="baseline">
          <Column overflow="hidden" className="text-muted" display="block">{@props.album.artistName?.join(", ")}</Column>
          <Column flex="initial" overflow="hidden"className="text-right"><small className="text-muted">{@props.album.genre?.join(', ')}</small></Column>
        </Row>
      </Column>
    </ListItem>

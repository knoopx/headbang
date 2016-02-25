React = require("react")
moment = require("moment")

ListItem = require('./list-item')
Artwork = require("./artwork")
Star = require("./star")
Tag = require("./tag")

{Column, Row, Gutter} = require("./layout")

module.exports = React.createClass
  displayName: "AlbumListItem"

  shouldComponentUpdate: (nextProps, nextState) ->
    @props.album != nextProps.album

  getInitialState: ->
    agents: @getAgents(@props.album)

  componentWillReceiveProps: (nextProps) ->
    @setState(@getAgents(nextProps.album))

  getAgents: (album) ->
    agents = []
    agents.push(<i key="lastfm" className="fa fa-lastfm text-muted" style={margin: "0 2px"} title="last.fm" />) if album.lastfm?
    agents.push(<i key="discogs" className="fa fa-dot-circle-o text-muted" style={margin: "0 2px"} title="discogs" />) if album.discogs?
    agents

  render: ->
    <ListItem>
      <Column flex="initial" style={{alignSelf:"center", textAlign: "center"}}>
        <small>{@props.album.playCount}</small>
        <Star album={@props.album} />
      </Column>

      <Gutter/>

      <Column flex="initial" onClick={@handleSelect}>
        <Row><Artwork src={@props.album.artwork} size={40} /></Row>
      </Column>

      <Gutter/>

      <Column onClick={@handleSelect}>
        <Row alignItems="baseline">
          <Column flex="2 0 auto" overflow="hidden" display="block">
            <Row alignItems="center" title={@props.album.basename}>
              <Column overflow="hidden" flex="initial" display="block">
                <Row><strong>{@props.album.name}</strong></Row>
              </Column>

              {<Gutter/> if @props.album.tag.length > 0}

              <Column overflow="hidden" flex="initial">
                <Row>{@props.album.tag.map((tagName) -> <Tag key={tagName} name={tagName}/>)}</Row>
              </Column>

              <Gutter size={6}/>

              <Column overflow="hidden" flex="initial">
                <Row><small className="text-muted">{moment(@props.album.indexedAt).fromNow()}</small></Row>
              </Column>
            </Row>
          </Column>

          <Gutter size={6}/>

          <Column flex="0 2 auto" overflow="hidden" display="block">
            <small className="text-muted">{(@props.album.year.concat(@props.album.label).compact().join(', '))}</small>
          </Column>
        </Row>

        <Row alignItems="baseline">
          <Column flex="2 0 auto" overflow="hidden" className="text-muted">
            <Row alignItems="center">
              {@props.album.artistName?.join(", ")}
              <Gutter size={4} />
              {@state.agents}
            </Row>
          </Column>

          <Gutter size={6}/>

          <Column flex="0 2 auto" overflow="hidden">
            <Row><small className="text-muted">{@props.album.genre?.join(', ')}</small></Row>
          </Column>
        </Row>
      </Column>
    </ListItem>

  handleSelect: (e) ->
    @props.onSelect(@props.album, e)

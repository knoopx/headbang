React = require("react")

ListItem = require('./list-item')
{Gutter} = require("./layout")

module.exports = React.createClass
  displayName: "PlayListItem"
  mixins: [require('react-immutable-render-mixin')]

  onSelect: ->
    @props.onSelect(@props.item)

  render: ->
    <ListItem active={@props.active} onClick={@onSelect}>
      <strong>{@props.item.track.name}</strong>
      <Gutter/>
      <span className="text-muted">{@props.item.track.artistName?.join(", ")}</span>
    </ListItem>

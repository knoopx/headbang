React = require("react")
VirtualList = require('./virtual-list')

{Column, Row, Gutter} = require("./layout")
AlbumListItem = require('./album-list-item')

module.exports = React.createClass
  displayName: "AlbumList"
  mixins: [require('react-addons-pure-render-mixin')]

  getInitialState: ->
    itemHeight: 57

  render: ->
    <VirtualList ref="virtualList" className="list" items={@props.albums} renderItem={@renderItem} itemHeight={@state.itemHeight} />

  renderItem: (album) ->
    <AlbumListItem key={album.id} album={album} onSelect={@props.onSelect} style={width: @state.itemHeight}/>

  scrollToTop: ->
    @refs.virtualList?.scrollToTop()

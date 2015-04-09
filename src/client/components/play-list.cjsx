React = require("react")

{Column, Row, Gutter} = require("./layout")
VirtualList = require('./virtual-list')
PlayListItem = require("./play-list-item")

module.exports = React.createClass
  mixins: [require('react-addons-pure-render-mixin')]
  displayName: "PlayList"

  propTypes:
    items: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
    itemHeight: React.PropTypes.number.isRequired
    activeItem: React.PropTypes.object
    onSelect: React.PropTypes.func.isRequired

  getDefaultProps: ->
    items: []
    itemHeight: 37

  getInitialState: ->
    items: @props.items
    itemHeight: @props.itemHeight

  componentWillReceiveProps: (props) ->
    @setState(props)
    @refs.virtualList.forceUpdate() unless @props.activeItem == props.activeItem

  render: ->
    <VirtualList className="list" ref="virtualList" items={@state.items} renderItem={@renderItem} itemHeight={@state.itemHeight} />

  renderItem: (item, index) ->
    <PlayListItem key={index} active={@state.activeItem == item} item={item} onSelect={@props.onSelect} style={height: @state.itemHeight}/>

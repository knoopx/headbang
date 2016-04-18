React = require('react')
Immutable = require("immutable")
ImmutablePropTypes = require('react-immutable-proptypes')


module.exports = React.createClass
  displayName: 'VirtualList'
  mixins: [require('react-immutable-render-mixin')]

  propTypes:
    items: React.PropTypes.oneOfType([
      ImmutablePropTypes.list
      ImmutablePropTypes.map
    ]).isRequired
    itemHeight: React.PropTypes.number.isRequired
    renderItem: React.PropTypes.func.isRequired

  getInitialState: ->
    @getVirtualState(@props)

  componentWillReceiveProps: (nextProps) ->
    window.requestAnimationFrame =>
      @setState(@getVirtualState(nextProps))

  componentDidMount: ->
    window.addEventListener 'resize', @handleUpdate

  componentWillUnmount: ->
    window.removeEventListener 'resize', @handleUpdate

  handleUpdate: ->
    window.requestAnimationFrame =>
      @setState(@getVirtualState(@props))

  visibleItems: ->
    @state.items

  scrollToTop: ->
    @refs.container?.scrollTop = 0

  getStyle: ->
    height: @state.height - @state.offset
    transform: "translateZ(0) translateY(#{@state.offset}px)"

  render: ->
    <div className="virtual-list">
      <div className="virtual-list-inner" ref="container" onScroll={@handleUpdate}>
        <div className="list" {...@props} style={@getStyle()}>
          {@props.items.slice(@state.firstItemIndex, @state.lastItemIndex + 1).map(@props.renderItem).toArray()}
        </div>
      </div>
    </div>

  getVirtualState: (props) ->
    @getItems(@refs.container?.scrollTop, @refs.container?.clientHeight || -1, props.itemHeight, props.items.count())

  getItems: (viewTop, viewHeight, itemHeight, itemCount) ->
    if viewHeight <= 0 or itemCount <= 0 or itemHeight <= 0 or itemCount <= 0
      height: 0
      offset: 0
      firstItemIndex: -1
      lastItemIndex: -1
      itemsCount: 0
    else
      listHeight = itemHeight * itemCount
      viewBoxBottom = viewTop + viewHeight

      listViewBox =
        top: Math.max(0, viewTop)
        bottom: Math.max(0, Math.min(listHeight, viewBoxBottom))

      firstItemIndex = Math.max(0, Math.floor(listViewBox.top / itemHeight))
      lastItemIndex = Math.ceil(listViewBox.bottom / itemHeight) - 1
      itemsCount = lastItemIndex - firstItemIndex + 1

      height: listHeight
      firstItemIndex: firstItemIndex
      lastItemIndex: lastItemIndex
      offset: firstItemIndex * itemHeight
      itemsCount: itemsCount

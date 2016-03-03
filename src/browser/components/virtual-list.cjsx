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
    @setState(@getVirtualState(nextProps))

  componentDidMount: ->
    @refs.container.addEventListener 'scroll', @handleScroll
    @setState(@getVirtualState(@props))

  componentWillUnmount: ->
    @refs.container.removeEventListener 'scroll', @handleScroll

  handleScroll: ->
    @setState(@getVirtualState(@props))

  visibleItems: ->
    @state.items

  scrollToTop: ->
    @refs.container?.scrollTop = 0

  getStyle: ->
    height: @state.height - @state.bufferStart
    transform: "translateZ(0) translateY(#{@state.bufferStart}px)"

  render: ->
    <div className="virtual-list">
      <div className="virtual-list-inner" ref="container">
        <div className="list" {...@props} style={@getStyle()}>
          {@state.items.map(@props.renderItem).toArray()}
        </div>
      </div>
    </div>

  getVirtualState: (props) ->
    state =
      items: Immutable.List()
      bufferStart: 0
      height: props.items.count() * props.itemHeight
      clientHeight: @refs.container?.clientHeight || -1

    # no space to render
    return state if state.clientHeight <= 0

    # early return if nothing to render
    return state if props.items.count() == 0 or props.itemHeight <= 0

    renderStats = @getItems(@refs.container.scrollTop, @refs.container.clientHeight, props.itemHeight, props.items.count())

    # no items to render
    return state if renderStats.itemsCount == 0

    Object.merge state,
      items: props.items.slice(renderStats.firstItemIndex, renderStats.lastItemIndex + 1)
      firstItemIndex: renderStats.firstItemIndex
      bufferStart: renderStats.firstItemIndex * props.itemHeight

  getItems: (viewTop, viewHeight, itemHeight, itemCount) ->
    if itemCount == 0 or itemHeight == 0
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

      firstItemIndex: firstItemIndex
      lastItemIndex: lastItemIndex
      itemsCount: itemsCount

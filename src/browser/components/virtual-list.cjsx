React = require('react')

areArraysEqual = (a, b) ->
  return false if !a? || !b?
  return false if a.length != b.length
  for item, i in a
    return false if a[i] != b[i]
  true

module.exports = React.createClass
  displayName: 'VirtualList'

  propTypes:
    items: React.PropTypes.array.isRequired
    itemHeight: React.PropTypes.number.isRequired
    renderItem: React.PropTypes.func.isRequired

  getInitialState: ->
    @getVirtualState(@props)

  shouldComponentUpdate: (nextProps, nextState) ->
    (@state.bufferStart != nextState.bufferStart) || (@state.height != nextState.height) || !areArraysEqual(@state.items, nextState.items)

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
          {@state.items.map(@props.renderItem)}
        </div>
      </div>
    </div>

  getVirtualState: (props) ->
    state =
      items: []
      bufferStart: 0
      height: 0

    # early return if nothing to render
    return state if !@refs.container? or props.items.length == 0 or props.itemHeight <= 0 or !@state?

    state.height = props.items.length * props.itemHeight

    # no space to render
    return state if @refs.container.clientHeight <= 0

    renderStats = @getItems(@refs.container.scrollTop, @refs.container.clientHeight, props.itemHeight, props.items.length)

    # no items to render
    return state if renderStats.itemsInView.length == 0

    Object.merge state,
      items: props.items.slice(renderStats.firstItemIndex, renderStats.lastItemIndex + 1)
      firstItemIndex: renderStats.firstItemIndex
      bufferStart: renderStats.firstItemIndex * props.itemHeight

  getItems: (viewTop, viewHeight, itemHeight, itemCount) ->
    if itemCount == 0 or itemHeight == 0
      firstItemIndex: -1
      lastItemIndex: -1
      itemsInView: 0
    else
      listHeight = itemHeight * itemCount
      viewBoxBottom = viewTop + viewHeight

      listViewBox =
        top: Math.max(0, viewTop)
        bottom: Math.max(0, Math.min(listHeight, viewBoxBottom))

      firstItemIndex = Math.max(0, Math.floor(listViewBox.top / itemHeight))
      lastItemIndex = Math.ceil(listViewBox.bottom / itemHeight) - 1
      itemsInView = lastItemIndex - firstItemIndex + 1

      firstItemIndex: firstItemIndex
      lastItemIndex: lastItemIndex
      itemsInView: itemsInView

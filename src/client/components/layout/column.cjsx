React = require("react")

module.exports = React.createClass
  displayName: "Column"

  getDefaultProps: ->
    display: "flex"
    flex: 1
    overflow: "initial"
    alignItems: "initial"
    alignSelf: "initial"

  getStyle: ->
    display: @props.display
    flex: @props.flex
    flexDirection: "column"
    flexWrap: "wrap"
    overflow: @props.overflow
    textOverflow: "ellipsis"
    whiteSpace: "nowrap"
    alignItems: @props.alignItems
    alignSelf: @props.alignSelf
    minWidth: 0

  render: ->
    <div className="column" style={@getStyle()} {...@props}>{@props.children}</div>

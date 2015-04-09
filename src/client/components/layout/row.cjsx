React = require("react")

module.exports = React.createClass
  displayName: "Row"

  getDefaultProps: ->
    display: "flex"
    flex: 1
    overflow: "initial"
    alignItems: "initial"
    alignSelf: "initial"

  getStyle: ->
    display: @props.display
    flex: @props.flex
    flexDirection: "row"
    flexWrap: "wrap"
    width: "100%"
    overflow: @props.overflow
    textOverflow: "ellipsis"
    whiteSpace: "nowrap"
    alignItems: @props.alignItems
    alignSelf: @props.alignSelf
    minWidth: 0

  render: ->
    <div className="row" style={@getStyle()} {...@props}>{@props.children}</div>

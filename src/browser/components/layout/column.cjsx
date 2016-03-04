React = require("react")
support = require("../../../common/support")

module.exports = React.createClass
  displayName: "Column"
  mixins: [require('react-immutable-render-mixin')]

  getDefaultProps: ->
    display: "flex"
    flex: 1

  getStyle: ->
    display: @props.display
    flex: @props.flex
    flexDirection: "column"
    flexWrap: "wrap"
    overflow: @props.overflow
    textOverflow: "ellipsis"
    whiteSpace: "nowrap"
    padding: @props.padding
    alignItems: @props.alignItems
    alignSelf: @props.alignSelf
    minWidth: 0

  render: ->
    <div className="column" {...@props} style={support.merge(@getStyle(), @props.style)}/>

React = require("react")

module.exports = React.createClass
  displayName: "Spinner"
  mixins: [require('react-immutable-render-mixin')]

  getDefaultProps: ->
    size: 32

  getStyle: ->
    width: "#{@props.size}px"
    height: "#{@props.size}px"

  render: ->
    <div style={@getStyle()} className="spinner">
      <div className="bar bar1"></div>
      <div className="bar bar2"></div>
      <div className="bar bar3"></div>
    </div>

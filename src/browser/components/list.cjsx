React = require("react")

module.exports = React.createClass
  displayName: "List"
  render: ->
    <div className="list">{@props.children}</div>

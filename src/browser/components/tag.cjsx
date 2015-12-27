React = require("react")

module.exports = React.createClass
  displayName: "Tag"
  render: -> <span className="tag">{@props.name}</span>

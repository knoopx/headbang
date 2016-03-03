React = require("react")

module.exports = React.createClass
  displayName: "Tag"
  mixins: [require('react-immutable-render-mixin')]

  render: -> <span className="tag">{@props.name}</span>

React = require("react")

module.exports = React.createClass
  displayName: "Tag"
  mixins: [require('react-addons-pure-render-mixin')]

  render: -> <span className="tag">{@props.name}</span>

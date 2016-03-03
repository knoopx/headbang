React = require("react")

module.exports = React.createClass
  displayName: "List"
  mixins: [require('react-immutable-render-mixin')]

  render: ->
    <div className="list">{@props.children}</div>

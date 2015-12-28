React = require("react")

module.exports = React.createClass
  displayName: "List"
  mixins: [require('react-addons-pure-render-mixin')]

  render: ->
    <div className="list">{@props.children}</div>

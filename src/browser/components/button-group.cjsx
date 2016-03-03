React = require("react")

module.exports = React.createClass
  displayName: "ButtonGroup"
  mixins: [require('react-immutable-render-mixin')]
  render: ->
    <div className="btn-group" {...@props} />

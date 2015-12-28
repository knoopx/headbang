React = require("react")

module.exports = React.createClass
  displayName: "ButtonGroup"
  mixins: [require('react-addons-pure-render-mixin')]
  render: ->
    <div className="btn-group" {...@props} />

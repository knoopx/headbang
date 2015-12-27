React = require("react")

module.exports = React.createClass
  displayName: "ListItem"

  getClassName: ->
    classNames = ["list-item"]
    classNames.push("active") if @props.active
    classNames.join(" ")

  render: ->
    <div className={@getClassName()} {...@props}>{@props.children}</div>

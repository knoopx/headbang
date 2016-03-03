React = require("react")
axios = require("axios")

module.exports = React.createClass
  displayName: "Star"
  mixins: [require('react-immutable-render-mixin')]

  toggle: ->
    axios.patch("/albums/#{@props.album.id}", starred: !!!@props.album.starred).then =>
      @forceUpdate()

  render: ->
    if @props.album.starred
      <i className="fa fa-star" onClick={@toggle}></i>
    else
      <i className="fa fa-star-o" onClick={@toggle}></i>

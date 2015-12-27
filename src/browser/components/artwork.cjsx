React = require("react")
async = require("async")
Spinner = require("./spinner")

queue = async.queue (fn, done) ->
  fn(done)
, 10

ArtworkImage = React.createClass
  displayName: "Artwork"

  getInitialState: ->
    isLoading: true

  componentDidMount: (props) ->
    @setSource(@props.src)

  componentWillReceiveProps: (props) ->
    @setSource(props.src) unless @props.src == props.src

  setSource: (src) ->
    setTimeout =>
      if @isMounted()
        queue.unshift (done) =>
          if @isMounted()
            img = new Image()
            img.onload = done
            img.src = src
          else done()
        , =>
          @setState(isLoading: false) if @isMounted()
    , 200

  render: ->
    if @state.isLoading
      <Spinner size={Math.round(@props.size * 0.5)} />
    else
      <div style={backgroundImage: "url('#{@props.src}')", width: "#{@props.size}px", height: "#{@props.size}px"} className="artwork-image"></div>

module.exports = React.createClass
  displayName: "Artwork"
  mixins: [require('react-addons-pure-render-mixin')]

  getDefaultProps: ->
    size: 64

  render: ->
    <div className="artwork" style={width: "#{@props.size}px", height: "#{@props.size}px"}>
      {@renderContent()}
    </div>

  renderContent: ->
    if @props.src?.length > 0
      <ArtworkImage src={@props.src} size={@props.size} />

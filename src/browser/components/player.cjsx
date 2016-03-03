React = require("react")
ReactDOM = require("react-dom")

Format = require("../../common/format")

Button = require("./button")
ButtonGroup = require("./button-group")
{Column, Row, Gutter, Divider} = require("./layout")

module.exports = React.createClass
  displayName: "Player"

  mixins: [
    require("./mixins/key-bindings")
    require('react-immutable-render-mixin')
  ]

  propTypes:
    audio: React.PropTypes.object.isRequired
    onTrackEnd: React.PropTypes.func.isRequired
    onPlayPrev: React.PropTypes.func
    onPlayNext: React.PropTypes.func

  getDefaultProps: ->
    audio: new Audio()

  getInitialState: ->
    window.playerState or
      audio: @props.audio
      duration: @props.audio.duration
      time: @props.audio.currentTime
      isPlaying: !@props.audio.paused

  componentDidMount: ->
    module.onReload? => window.playerState = @state
    @state.audio.addEventListener("loadeddata", @handleDataLoaded)
    @state.audio.addEventListener("timeupdate", @handleTimeUpdate)
    @state.audio.addEventListener("play", @handlePlay)
    @state.audio.addEventListener("pause", @handlePause)
    @state.audio.addEventListener("ended", @handleEnded)

    @bindKey "space", (e) =>
      @playOrPause()
      e.preventDefault()
    @bindKey "shift+right", (e) =>
      @props.onPlayNext()
      e.preventDefault()

    @bindKey "shift+left", (e) =>
      @props.onPlayPrev()
      e.preventDefault()

  componentWillUnmount: ->
    @state.audio.removeEventListener("loadeddata", @handleDataLoaded)
    @state.audio.removeEventListener("timeupdate", @handleTimeUpdate)
    @state.audio.removeEventListener("play", @handlePlay)
    @state.audio.removeEventListener("pause", @handlePause)
    @state.audio.removeEventListener("ended", @handleEnded)

  handleDataLoaded: ->
    @setState(duration: @state.audio.duration)

  handleTimeUpdate: ->
    @setState(time: @state.audio.currentTime)

  handlePlay: ->
    @setState(isPlaying: true)

  handlePause: ->
    @setState(isPlaying: false)

  handleEnded: ->
    @props.onTrackEnd()

  play: ->
    @state.audio.play()

  pause: ->
    @state.audio.pause()

  load: (src) ->
    @state.audio.src = src

  playOrPause: ->
    if @state.isPlaying
    then @state.audio.pause()
    else @state.audio.play()

  handleTimeSeek: (e) ->
    @state.audio.currentTime = e.target.value

  render: ->
    <Column>
      <Row padding="10px">
        <Column>
          <Row alignItems="center">
            <Column>
              <div className="range">
                <span className="time">{Format.duration(@state.time)}</span>
                <Gutter/>
                <input max={@state.duration} min="0" value={@state.time} onChange={@handleTimeSeek} type="range" tabIndex="-1" />
                <Gutter/>
                <span className="duration">{Format.duration(@state.duration || 0)}</span>
                <Gutter/>
              </div>
            </Column>

            <Gutter/>

            <Column flex="initial">
              <ButtonGroup>
                <Button onClick={@props.onPlayPrev}><i className="fa fa-backward" tabIndex="-1"></i></Button>
                <Button onClick={@playOrPause} tabIndex="-1">{@renderPlayOrPauseIcon()}</Button>
                <Button onClick={@props.onPlayNext} tabIndex="-1"><i className="fa fa-forward"></i></Button>
              </ButtonGroup>
            </Column>
          </Row>
        </Column>
      </Row>
    </Column>

  renderPlayOrPauseIcon: ->
    if @state.isPlaying
      <i className="fa fa-pause"></i>
    else
      <i className="fa fa-play"></i>

React = require("react")
ReactDOM = require("react-dom")
Combokeys = require('combokeys')

{Column, Row, Gutter, Divider} = require("./layout")
Format = require("../format")

module.exports = React.createClass
  displayName: "Player"

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
    module.onReload? =>
      window.playerState = @state
    @state.audio.addEventListener("loadeddata", @handleDataLoaded)
    @state.audio.addEventListener("timeupdate", @handleTimeUpdate)
    @state.audio.addEventListener("play", @handlePlay)
    @state.audio.addEventListener("pause", @handlePause)
    @state.audio.addEventListener("ended", @handleEnded)

    @combokeys = new Combokeys(document.documentElement)
    @combokeys.bind "space", (e) =>
      @playOrPause()
      e.preventDefault()
    @combokeys.bind "shift+right", @props.onPlayNext
    @combokeys.bind "shift+left", @props.onPlayPrev

  componentWillUnmount: ->
    @combokeys.detach()
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
      <Row className="wrapper">
        <Column>
          <Row alignItems="center">
            <Column>
              <div className="range">
                <span className="time">{Format.duration(@state.time)}</span>
                <Gutter/>
                <input max={@state.duration} min="0" value={@state.time} onChange={@handleTimeSeek} type="range" />
                <Gutter/>
                <span className="duration">{Format.duration(@state.duration)}</span>
                <Gutter/>
              </div>
            </Column>

            <Gutter/>

            <Column flex="initial">
              <div className="btn-group">
                <a onClick={@props.onPlayPrev} className="btn btn-default"><i className="fa fa-backward"></i></a>
                <a onClick={@playOrPause} className="btn btn-default">{@renderPlayOrPauseIcon()}</a>
                <a onClick={@props.onPlayNext} className="btn btn-default"><i className="fa fa-forward"></i></a>
              </div>
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

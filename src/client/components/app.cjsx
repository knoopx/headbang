React = require("react")
Combokeys = require('combokeys')

AlbumStore = require("../album-store")
TrackStore = require("../track-store")
JobStore = require("../job-store")
filter = require("../filter")
{io} = require("../events")

{Column, Row, Gutter, Divider} = require("./layout")
AlbumList = require("./album-list")
PlayList = require("./play-list")
NowPlaying = require("./now-playing")
Player = require("./player")
Spinner = require("./spinner")
List = require("./list")
ListItem = require("./list-item")
FilterGroup = require("./filter-group")
JobList = require("./job-list")

module.exports = React.createClass
  mixins: [
    require("./mixins/helpers")
    require('react-addons-pure-render-mixin')
  ]
  displayName: "App"

  restoreFilter: ->
    defaults =
      filter: {}
      query: null
      starred: @getItem("filter:starred")
      order: @getItem("filter:order", "ascending")

    Object.merge(defaults, @getQueryString().filter)

  restorePlaylist: ->
    @getItem("playlist:items", [])

  restorePlaylistIndex: ->
    @getItem("playlist:index", 0)

  getDefaultProps: ->
    orderFn:
      ascending: (album) -> [album.artistName?.sort().join().toLocaleLowerCase(), album.year, album.name.toLocaleLowerCase(), album.id]
      recent: (album) -> -album.indexedAt

  getInitialState: ->
    if window.previousState?
      window.previousState
    else
      playlist = @restorePlaylist()
      playlistIndex = @restorePlaylistIndex()

      isConnected: false
      albums: []
      jobs: []
      playlist: playlist
      filter: @restoreFilter()
      activePlaylistItem: playlist[playlistIndex]

  componentDidMount: ->
    module.onReload? =>
      window.previousState = @state

    @combokeys = new Combokeys(document.documentElement)
    @combokeys.bind "command+f", (e) =>
      if @refs.filter
        @refs.filter.focus()
        e.preventDefault()

    io.on "connect", @handleConnect
    io.on "disconnect", @handleDisconnect

  componentWillUnmount: ->
    @combokeys?.detach()
    AlbumStore.off "change", @reloadAlbums
    JobStore.off "change", @reloadJobs
    io.off "connect", @handleConnect
    io.off "disconnect", @handleDisconnect

  render: ->
    if @state.isConnected
      <Column>
        <Row className="toolbar" flex="initial">
          <Row alignItems="center">
            <Column className="wrapper">
              <FilterGroup ref="filter" filter={@state.filter} albums={@state.albums} onChange={@handleFilterChange} />
            </Column>
          </Row>
          <Row>
            <Player ref="player" onTrackEnd={@handleTrackEnded} onPlayPrev={@handlePlayPrev} onPlayNext={@handlePlayNext}/>
          </Row>
        </Row>

        <Divider />

        <Row>
          <Column>
            <Row>
              <AlbumList ref="albumList" albums={@state.albums} onSelect={@handleAlbumSelected} />
            </Row>
          </Column>

          <Divider vertical/>

          <Column>
            {<Row flex="initial"><NowPlaying item={@state.activePlaylistItem} /></Row> if @state.activePlaylistItem}
            {<Divider /> if @state.activePlaylistItem}
            <Row><PlayList ref="playlist" activeItem={@state.activePlaylistItem} items={@state.playlist} onSelect={@handlePlaylistItemSelected}/></Row>
          </Column>
        </Row>

        {<Divider /> if @state.jobs.length > 0}
        {<JobList jobs={@state.jobs} /> if @state.jobs.length > 0}
      </Column>
    else
      <Row alignItems="center">
        <Column alignItems="center">
          <Spinner size={128}/>
        </Column>
      </Row>

  handleConnect: ->
    AlbumStore.fetch().then =>
      @reloadAlbums()
      AlbumStore.on "change", @reloadAlbums

    JobStore.fetch().then =>
      @reloadJobs()
      JobStore.on "change", @reloadJobs

    @setState isConnected: true, => @refs.filter.focus()

  handleDisconnect: ->
    @setState isConnected: false, =>
      AlbumStore.ejectAll()
      JobStore.ejectAll()

  handleFilterChange: (filter) ->
    @setItem("filter:starred", filter.starred)
    @setItem("filter:order", filter.order)

    unless @state.filter == filter.filter
      @setDocumentTitle("Filter: #{Object.values(filter.filter).join(" ")}")
      @setQueryString(filter: {filter: filter.filter})

    @setState filter: filter, =>
      @reloadAlbums()
      @refs.albumList?.scrollToTop()

  handleTrackEnded: ->
    if next = @relativePlaylistItem()
      @play(next)

  handleAlbumSelected: (album) ->
    TrackStore.fetch(albumId: album.id).then (tracks) =>
      @clearPlaylist()
      items = tracks.sortBy("number").map (track) ->
        track: track
        album: album

      @setPlaylist(items)
      @play(items[0])

  handlePlaylistItemSelected: (item) ->
    @play(item)

  handlePlayNext: ->
    if item = @relativePlaylistItem()
      @play(item)

  handlePlayPrev: ->
    if item = @relativePlaylistItem(-1)
      @play(item)

  setPlaylist: (items) ->
    @setItem("playlist:items", items)
    @setState(playlist: items)

  clearPlaylist: ->
    @setPlaylist([])

  setActivePlaylistItem: (item, fn) ->
    @setItem("playlist:index", @state.playlist.indexOf(item))
    @setState(activePlaylistItem: item, fn)

  play: (item, fn) ->
    {track, album} = item
    @refs.player.pause()
    @refs.player.load("/tracks/#{track.id}/stream")
    @refs.player.play()
    @setActivePlaylistItem(item)
    document.title = "#{album.artistName} - #{track.name} (#{album.name})"

  relativePlaylistItem: (offset = 1) ->
    @state.playlist[@state.playlist.indexOf(@state.activePlaylistItem) + offset]

  reloadAlbums: (->
    query = Object.merge
      name: @state.filter.query
      starred: @state.filter.starred
    , @state.filter.filter

    orderFn = @props.orderFn[@state.filter.order]
    @setState(albums: filter(AlbumStore.sortBy(orderFn))(query).toArray())
  ).debounce(50)

  reloadJobs: (->
    @setState(jobs: JobStore.toArray())
  ).debounce(50)

React = require("react")
Immutable = require("immutable")

io = require("socket.io-client")()
firstBy = require('thenby')

AlbumStore = require("../store/album-store")
TrackStore = require("../store/track-store")
JobStore = require("../store/job-store")
filter = require("../../common/filter")

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
  displayName: "App"

  mixins: [
    require("./mixins/key-bindings")
    require("./mixins/helpers")
    require('react-immutable-render-mixin')
  ]

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
      ascending:
        firstBy((a) -> a.artistName.length)
        .thenBy((a) -> a.artistName?.sort().first().toLocaleLowerCase())
        .thenBy("year").thenBy((a) -> a.name.toLocaleLowerCase())
        .thenBy("id")

      recent: firstBy("indexedAt", -1).thenBy("id")
      playCount: firstBy("playCount", -1).thenBy("id")

  getInitialState: ->
    if window.previousState?
      window.previousState
    else
      playlist = @restorePlaylist()
      playlistIndex = @restorePlaylistIndex()

      isConnected: false
      albums: Immutable.Map()
      jobs: Immutable.Map()
      playlist: Immutable.List(playlist)
      filter: @restoreFilter()
      activePlaylistItem: playlist[playlistIndex]

  componentWillMount: ->
    io.on "connect", @handleConnect
    io.on "disconnect", @handleDisconnect

  componentDidMount: ->
    module.onReload? => window.previousState = @state
    @bindKey "command+f", (e) =>
      if @refs.filter
        @refs.filter.focus()
        e.preventDefault()

  componentWillUnmount: ->
    AlbumStore.off "change", @reloadAlbums
    JobStore.off "change", @reloadJobs

  render: ->
    if @state.isConnected
      <Column>
        <Row className="toolbar" flex="initial">
          <Row alignItems="center">
            <Column padding="10px">
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

        {<Divider /> if @state.jobs.count() > 0}
        {<JobList jobs={@state.jobs} /> if @state.jobs.count() > 0}
      </Column>
    else
      <Row alignItems="center">
        <Column alignItems="center">
          <Spinner size={128}/>
        </Column>
      </Row>

  handleConnect: ->
    io.on "inject:album", @handleAlbumInjected
    io.on "eject:album", @handleAlbumEjected
    io.on "inject:job", @handleJobInjected
    io.on "eject:job", @handleJobEjected

    AlbumStore.fetch().then =>
      @reloadAlbums()
      AlbumStore.on "change", @reloadAlbums

    JobStore.fetch().then =>
      @reloadJobs()
      JobStore.on "change", @reloadJobs

    @setState isConnected: true, => @refs.filter.focus()

  handleAlbumInjected: (album) ->
    AlbumStore.inject(album)

  handleAlbumEjected: (album) ->
    AlbumStore.eject(album)

  handleJobInjected: (job) ->
    JobStore.inject(job)

  handleJobEjected: (job) ->
    JobStore.eject(job)

  handleDisconnect: ->
    io.off "inject:album", @handleAlbumInjected
    io.off "eject:album", @handleAlbumEjected
    io.off "inject:job", @handleJobInjected
    io.off "eject:job", @handleJobEjected
    @setState
      isConnected: false
      albums: Immutable.Map()
      jobs: Immutable.Map()

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

  handleAlbumSelected: (album, e) ->
    shouldClearPlaylist = !e.shiftKey

    TrackStore.fetch(albumId: album.id).then (tracks) =>
      items = tracks.sortBy("number").map (track) ->
        track: track
        album: album

      if shouldClearPlaylist
        @clearPlaylist =>
          @setPlaylist(items)
          @play(items[0])
      else
        @setPlaylist(@state.playlist.concat(items))

  handlePlaylistItemSelected: (item) ->
    @play(item)

  handlePlayNext: ->
    if item = @relativePlaylistItem()
      @play(item)

  handlePlayPrev: ->
    if item = @relativePlaylistItem(-1)
      @play(item)

  setPlaylist: (items, fn) ->
    @setItem("playlist:items", items)
    @setState(playlist: Immutable.List(items), fn)

  clearPlaylist: (fn) ->
    @setPlaylist([], fn)

  setActivePlaylistItem: (item, fn) ->
    @setItem("playlist:index", @state.playlist.indexOf(item))
    @setState(activePlaylistItem: item, fn)

  play: (item, fn) ->
    {track, album} = item
    @refs.player.pause()
    @refs.player.load("/tracks/#{track.id}/stream")
    @refs.player.play()
    @setActivePlaylistItem(item, fn)
    document.title = "#{album.artistName} - #{track.name} (#{album.name})"

  relativePlaylistItem: (offset = 1) ->
    @state.playlist.get(@state.playlist.indexOf(@state.activePlaylistItem) + offset)

  reloadAlbums: (->
    query = Object.merge
      name: @state.filter.query
      starred: @state.filter.starred
    , @state.filter.filter
    orderFn = @props.orderFn[@state.filter.order]
    @setState(albums: AlbumStore.where(query).sort(orderFn))
  ).debounce(50)

  reloadJobs: (->
    @setState(jobs: JobStore.map)
  ).debounce(50)

React = require("react")
Immutable = require("immutable")
levenshtein = require('fast-levenshtein')

AlbumStore = require("../store/album-store")
filter = require("../../common/filter")

{Column, Row, Gutter, Divider} = require("./layout")
Spinner = require("./spinner")
SuggestionList = require("./suggestion-list")

module.exports = React.createClass
  displayName: "FilterGroup"

  mixins: [
    require('react-addons-pure-render-mixin')
    require("react-addons-linked-state-mixin")
  ]

  suggestTimeout: null

  propTypes: ->
    albums: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
    starred: React.PropTypes.boolean.isRequired
    query: React.PropTypes.string.isRequired
    filter: React.PropTypes.object.isRequired
    order: React.PropTypes.string.isRequired
    orderModes: React.PropTypes.arrayOf(React.PropTypes.string).isRequired
    onChange: React.PropTypes.function

  getDefaultProps: ->
    orderModes: ["ascending", "recent", "playCount"]
    albums: []
    filter:
      starred: null
      query: null
      filter: {}
      order: null

  getInitialState: ->
    albums: @props.albums

    suggestions: []
    isLoading: false

    filter: @props.filter.filter
    query: @props.filter.query
    starred: @props.filter.starred
    order: @props.filter.order || @props.orderModes[0]

  componentWillReceiveProps: (props) ->
    @setState(albums: props.albums) unless @props.albums == props.albums
    unless @props.filter == props.filter
      @setFilter(props.filter)

  setFilter: (filter) ->
    unless @props.filter == filter.filter
      @setState(filter: filter.filter)

    unless @props.query == filter.query
      @setState(query: filter.query)

    unless @props.starred == filter.starred
      @setState(starred: filter.starred)

    unless @props.order == filter.order
      @setState(order: filter.order)

  render: ->
    <div className="filter-group">
      {<Spinner size={14} /> if @state.isLoading}
      {<i className="fa fa-search" /> unless @state.isLoading}
      <Gutter size={6} />
      {Object.keys(@state.filter).map((key) => @renderFilter(key, @state.filter[key]))}
      {<Gutter /> if Object.size(@state.filter) > 0}
      <input ref="query" placeholder="type to filter..." type="text" onKeyDown={@handleKeyDown} valueLink={value: @state.query, requestChange: @handleQueryChange} />
      <Gutter />
      <div className="text-right text-muted"><em>{@state.albums.length} album(s)</em></div>
      <Gutter />
      <div className="filter-group-actions">
        {<i className="fa fa-times" onClick={@clearQuery}></i> if @state.query?.length > 0}
        {<Gutter/> if @state.query?.length > 0}
        {<i className="fa fa-clock-o" onClick={@handleOrderChange}></i> if @state.order == "recent"}
        {<i className="fa fa-sort-alpha-asc" onClick={@handleOrderChange}></i> if @state.order == "ascending"}
        {<i className="fa fa-play" onClick={@handleOrderChange}></i> if @state.order == "playCount"}
        <Gutter/>
        <i className={if @state.starred then "fa fa-star" else "fa fa-star-o"} onClick={@handleStarredClick}></i>
      </div>
      {<SuggestionList ref="suggestions" suggestions={@state.suggestions} onAcceptSuggestion={@handleAcceptSuggestion} onDismiss={@handleDismissSuggestions} /> if @state.suggestions.length > 0}
    </div>

  renderFilter: (type, value) ->
    <div key={type} className="filter-group-filter">
      <span>{type}</span> <strong>{value}</strong>
      <i className="fa fa-times" onClick={=> @removeFilter(type)}></i>
    </div>

  buildSuggestions: (albums, types = ["artistName", "genre", "label", "year", "country", "tag"]) ->
    suggestions = {}
    types.forEach (type) ->
      suggestions[type] = Immutable.Set()

    albums.forEach (album) ->
      types.map (type) ->
        for value in album[type] || []
          suggestions[type] = suggestions[type].add(value.toLocaleLowerCase().trim())

    list = Object.keys(suggestions).map (type) ->
      suggestions[type].toArray().map (value) ->
        type: type
        value: value

    Immutable.List(list.flatten())

  handleAcceptSuggestion: (suggestion) ->
    f = {}
    f[suggestion.type] = suggestion.value

    @handleDismissSuggestions =>
      @notifyChange
        query: null
        filter: Object.merge(@state.filter, f)

  handleDismissSuggestions: (fn) ->
    @setState(suggestions: [], fn)

  handleKeyDown: (e) ->
    @refs.suggestions?.handleKeyDown(e)
    unless e.defaultPrevented
      switch e.key
        when "Enter"
          @setState
            query: e.target.value
          , @notifyChange
          e.preventDefault()
        when "Backspace"
          if e.target.selectionStart == 0 && e.target.selectionStart == e.target.selectionEnd
            @removeFilter(Object.keys(@state.filter).last()) if Object.size(@state.filter) > 0
            e.preventDefault()

  handleQueryChange: (query) ->
    @setState
      isLoading: true
      suggestions: []
    , =>
      @notifyChange(query: query)
      clearTimeout(@suggestTimeout) if @suggestTimeout?
      @suggestTimeout = setTimeout =>
        if query?.length > 1
          suggestions = @buildSuggestions(filter(AlbumStore)(Object.merge(starred: @state.starred, @state.filter)))
          matches = filter(suggestions)(value: query)
            .sortBy (s) => levenshtein.get(s.value, query)
            .take(10)
            .toArray()
          @setState
            isLoading: false
            suggestions: matches.map (match) =>
              f = Object.clone(@state.filter)
              f[match.type] = match.value
              Object.merge match,
                count: filter(AlbumStore)(Object.merge({starred: @state.starred}, f)).count()
              match
          , =>
            @suggestTimeout = null
        else
          @setState(isLoading: false)
      , 500

  handleStarredClick: ->
    @notifyChange(starred: if @state.starred then null else true)

  handleOrderChange: ->
    index = @props.orderModes.indexOf(@state.order)
    if index + 1 < @props.orderModes.length
      @notifyChange(order: @props.orderModes[index + 1])
    else
      @notifyChange(order: @props.orderModes[0])

  clearQuery: ->
    @notifyChange(query: null)

  focus: ->
    @refs.query.focus()

  notifyChange: (changes = {}) ->
    @props.onChange?(Object.merge(Object.select(@state, ["filter", "query", "starred", "order"]), changes))

  removeFilter: (type) ->
    @notifyChange(filter: Object.reject(@state.filter, [type]))

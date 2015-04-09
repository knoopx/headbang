React = require("react")

List = require('./list')
ListItem = require('./list-item')
{Column, Row, Gutter, Divider} = require("./layout")

module.exports = React.createClass
  displayName: "SuggestionList"

  mixins: [
    require('react-onclickoutside')
    require('react-addons-pure-render-mixin')
  ]

  getDefaultProps: ->
    activeIndex: 0
    suggestions: []

  getInitialState: ->
    activeIndex: @props.activeIndex
    suggestions: @props.suggestions

  componentWillReceiveProps: (props) ->
    unless @state.suggestions == props.suggestions
      @setState
        activeIndex: 0
        suggestions: props.suggestions

  handleAcceptSuggestion: (index) ->
    if suggestion = @state.suggestions[index]
      @props.onAcceptSuggestion(suggestion)

  handleClickOutside: ->
    @dismiss()

  handleKeyDown: (e) ->
    switch e.key
      when "ArrowUp"
        @selectPrev()
        e.preventDefault()
      when "ArrowDown"
        @selectNext()
        e.preventDefault()
      when "Enter"
        @handleAcceptSuggestion(@state.activeIndex)
        e.preventDefault()
      when "Escape"
        @dismiss()
        e.preventDefault()

  dismiss: ->
    @props.onDismiss()

  selectPrev: ->
    @setState(activeIndex: Math.max(0, @state.activeIndex - 1))

  selectNext: ->
    @setState(activeIndex: Math.min(@state.suggestions.length - 1, @state.activeIndex + 1))

  render: ->
    <div className="filter-group-suggestions ignore-react-onclickoutside">
      <List>{@state.suggestions.map(@renderSuggestion)}</List>
    </div>

  renderSuggestion: (suggestion, index) ->
    <ListItem key={index} active={@state.activeIndex == index} onClick={=> @handleAcceptSuggestion(index)}>
      <Row alignItems="baseline">
        <strong>{suggestion.value}</strong>
        <Gutter/>
        <small className="text-muted">{suggestion.type}</small>
      </Row>
    </ListItem>

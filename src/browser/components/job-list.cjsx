React = require("react")

Format = require("../../common/format")

{Column, Row, Gutter, Divider} = require("./layout")
List = require("./list")
ListItem = require("./list-item")
VirtualList = require('./virtual-list')

module.exports = React.createClass
  displayName: "JobList"
  mixins: [require('react-addons-pure-render-mixin')]

  getDefaultProps: ->
    jobs: []
    isCollapsed: true
    itemHeight: 37

  getInitialState: ->
    @props

  componentDidMount: ->
    @interval = setInterval =>
      @refs.virtualList?.forceUpdate()
    , 1000

  componentWillUnmount: ->
    clearInterval(@interval)

  componentWillReceiveProps: (props) ->
    unless @props.jobs == props.jobs
      @setState
        jobs: props.jobs.sortBy (job) -> [job.startedAt, job.message]

  render: ->
    <Row flex={"initial" if @state.isCollapsed}  onClick={@handleToggled}>
      <Column>{@renderList()}</Column>
    </Row>

  renderList: ->
    if @state.isCollapsed
      <List><ListItem>{@state.jobs.last()?.message}</ListItem></List>
    else
      <Row>
        <VirtualList className="list" ref="virtualList" items={@state.jobs} renderItem={@renderItem} itemHeight={@state.itemHeight} />
      </Row>

  renderItem: (job, index) ->
    <ListItem key={job.id}>
      <Row>
        <Column display="block" overflow="hidden">{job.message}</Column>
        <Column flex="initial">{Format.duration((Date.now() - job.startedAt) / 1000)}</Column>
      </Row>
    </ListItem>

  handleToggled: ->
    @setState(isCollapsed: !@state.isCollapsed)
    @refs.virtualList?.forceUpdate()

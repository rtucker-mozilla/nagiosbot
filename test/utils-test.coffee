Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/nagiosbot-dispatch.coffee')
utils = require '../scripts/utils.coffee'

describe 'utils.removeName', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'replaced name correctly for slack', ->
    @robot.adapterName = "slack"
    message = "@#{@robot.name} status foo bar baz"
    properMessage = "status foo bar baz"
    messageWithNameRemoved = utils.removeName(@robot, message)
    expect(messageWithNameRemoved).to.equal(properMessage)

  it 'replaced name correctly for slack with : and space after bot name', ->
    @robot.adapterName = "slack"
    message = "@#{@robot.name}: status foo bar baz"
    properMessage = "status foo bar baz"
    messageWithNameRemoved = utils.removeName(@robot, message)
    expect(messageWithNameRemoved).to.equal(properMessage)

  it 'replaced name correctly for slack with : and no space after bot name', ->
    @robot.adapterName = "slack"
    message = "@#{@robot.name}:status foo bar baz"
    properMessage = "status foo bar baz"
    messageWithNameRemoved = utils.removeName(@robot, message)
    expect(messageWithNameRemoved).to.equal(properMessage)

  it 'replaced name correctly for irc no space between bot name and :', ->
    @robot.adapterName = "slack"
    message = "#{@robot.name}:status foo bar baz"
    properMessage = "status foo bar baz"
    messageWithNameRemoved = utils.removeName(@robot, message)
    expect(messageWithNameRemoved).to.equal(properMessage)

  it 'replaced name correctly for irc space between bot name and :', ->
    @robot.adapterName = "slack"
    message = "#{@robot.name}: status foo bar baz"
    properMessage = "status foo bar baz"
    messageWithNameRemoved = utils.removeName(@robot, message)
    expect(messageWithNameRemoved).to.equal(properMessage)
    
  it 'replaced name correctly for irc with space between bot name and no :', ->
    @robot.adapterName = "slack"
    message = "#{@robot.name} status foo bar baz"
    properMessage = "status foo bar baz"
    messageWithNameRemoved = utils.removeName(@robot, message)
    expect(messageWithNameRemoved).to.equal(properMessage)

describe 'utils.actionIndex', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'actionIndex set properly 1st item', ->
    message = "status foo bar baz"
    expect(utils.actionIndex('status', message)).to.equal(0)

  it 'actionIndex set properly last item', ->
    message = "status foo bar baz"
    expect(utils.actionIndex('baz', message)).to.equal(3)

  it 'actionIndex set properly middle item', ->
    message = "status foo bar baz"
    expect(utils.actionIndex('foo', message)).to.equal(1)

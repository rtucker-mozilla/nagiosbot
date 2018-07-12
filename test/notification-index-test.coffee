Helper = require('hubot-test-helper')
chai = require 'chai'
sinon = require 'sinon'

expect = chai.expect
helper = new Helper('../scripts/nagiosbot-dispatch.coffee')

notificationIndex = require '../scripts/notification-index.coffee'

describe 'notification-index', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'constructor sets currentIndex', ->
    robot = {}
    robot.brain = {}
    robot.brain.get = () ->
      return null
    robot.brain.set = (val) ->
      return null
    ni = new notificationIndex.NotificationIndex(robot, 1000, 1000)
    expect(ni.currentIndex).to.equal(1000)

  it 'constructor sets maxIndex', ->
    robot = {}
    robot.brain = {}
    robot.brain.get = () ->
      return null
    robot.brain.set = (val) ->
      return null
    ni = new notificationIndex.NotificationIndex(robot, 1000, 1000)
    expect(ni.maxIndex).to.equal(1999)

  it 'constructor sets proper nextIndex when dataSource is empty', ->
    robot = {}
    robot.brain = {}
    robot.brain.get = () ->
      return null
    robot.brain.set = (val) ->
      return null
    ni = new notificationIndex.NotificationIndex(robot, 1000, 1000)
    expect(ni.getNextIndex()).to.equal(1000)

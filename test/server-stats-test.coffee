Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/nagiosbot-dispatch.coffee')
ss = require '../scripts/server-stats.coffee'
fs = require('fs')

describe 'server-stats', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'return proper host count from livestatus response', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    livestatusHostCount = ss.livestatusHostsCount(livestatusResponse)
    properHostCount = 12
    expect(livestatusHostCount).to.equal(properHostCount)

  it 'return proper services count from livestatus response', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    livestatusServicesCount = ss.livestatusServicesCount(livestatusResponse)
    expect(livestatusServicesCount).to.equal(12)

  it 'return proper hosts up count', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    expect(ss.livestatusHostsUpCount(livestatusResponse)).to.equal(9)

  it 'return proper hosts warning count', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    expect(ss.livestatusHostsWarningCount(livestatusResponse)).to.equal(1)

  it 'return proper hosts down count', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    expect(ss.livestatusHostsDownCount(livestatusResponse)).to.equal(1)

  it 'return proper services up count', ->
    livestatusResponse = fs.readFileSync "test/fixtures/serviceresponse", 'utf8'
    expect(ss.livestatusServicesUpCount(livestatusResponse)).to.equal(7)

  it 'return proper services warning count', ->
    livestatusResponse = fs.readFileSync "test/fixtures/serviceresponse", 'utf8'
    expect(ss.livestatusServicesWarningCount(livestatusResponse)).to.equal(2)

  it 'return proper services down count', ->
    livestatusResponse = fs.readFileSync "test/fixtures/serviceresponse", 'utf8'
    expect(ss.livestatusServicesDownCount(livestatusResponse)).to.equal(3)

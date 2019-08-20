process.env.HUBOT_MOCK_MKLIVE_STATUS="true"
moment = require('moment');
Helper = require('hubot-test-helper')
helper = new Helper([
  '../scripts/nagiosbot-recheck.coffee',
])

co     = require('co')
expect = require('chai').expect
commandRecheck = require('../scripts/command-recheck.coffee')

re = /ack\s+(\d+)$/i
describe 'ack', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)
  afterEach ->
    @room.destroy()

  context 'CommandRecheck class for Host', ->

    beforeEach ->
      @input =  ""

    it 'should set proper unixtimestamp', ->
      ca = new commandRecheck.CommandRecheck({})
      expect(ca.getTimestamp(moment())).to.eql moment().unix()
      
    it 'should set proper verb', ->
      ca = new commandRecheck.CommandRecheck(
        'test.host.com',
        null,
        null,
      )
      m = moment()
      expect(ca.verb).to.eql "SCHEDULE_FORCED_HOST_CHECK"

    it 'command string is correct', ->
      ca = new commandRecheck.CommandRecheck(
        'test.host.com',
        null,
        null,
      )
      ca.interpolate()
      expect(ca.commandString).to.eql 'SCHEDULE_FORCED_HOST_CHECK;test.host.com;' + moment().unix()
      
      
  context 'CommandRecheck class for Service', ->

    beforeEach ->
      @input =  ""

    it 'should set proper unixtimestamp', ->
      ca = new commandRecheck.CommandRecheck({})
      m = moment()
      expect(ca.getTimestamp(m)).to.eql moment().unix()
      
    it 'should set proper verb', ->
      ca = new commandRecheck.CommandRecheck(
        'test.host.com',
        'Service Name',
        null,
      )
      m = moment()
      expect(ca.verb).to.eql "SCHEDULE_FORCED_SVC_CHECK"
      
    it 'should set proper service name', ->
      ca = new commandRecheck.CommandRecheck(
        'test.host.com',
        'Service Name',
        null,
      )
      m = moment()
      ca.interpolate()
      expect(ca.service).to.eql "Service Name"
      
    it 'command string is correct', ->
      ca = new commandRecheck.CommandRecheck(
        'test.host.com',
        'Service Name',
        null,
      )
      ca.interpolate()
      expect(ca.commandString).to.eql 'SCHEDULE_FORCED_SVC_CHECK;test.host.com;Service Name;' + moment().unix()
      
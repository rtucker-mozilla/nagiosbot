process.env.HUBOT_MOCK_MKLIVE_STATUS="true"
moment = require('moment');
Helper = require('hubot-test-helper')
helper = new Helper([
  '../scripts/nagiosbot-ack.coffee',
])

co     = require('co')
expect = require('chai').expect
commandAck = require('../scripts/command-ack.coffee')

re = /ack\s+(\d+)$/i
describe 'ack', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)
  afterEach ->
    @room.destroy()

  context 'downtime all services by hostname only', ->
    beforeEach ->
      co =>
        yield @room.user.say 'bob', '@hubot: downtime host.domain.com 1d message here'


  context 'downtime all services by hostname with wildcard', ->
    beforeEach ->
      co =>
        yield @response = @room.user.say 'bob', '@hubot: downtime host.domain.com:* 1d message here'

    
    #it 'should reply to user', ->
    #  response = "@bob Downtime for host.domain.com scheduled for 1 day"
    #  expect(@room.messages).to.eql [
    #    ['bob',   '@hubot: downtime host.domain.com:* 1d message here']
    #    ['hubot', response]
    #  ]

  context 'CommandDowntime class for Host', ->

    beforeEach ->
      @input =  ""

    it 'should set proper unixtimestamp', ->
      ca = new commandAck.CommandAck({})
      m = moment()
      expect(ca.getTimestamp(m)).to.eql moment().unix()
      
    it 'should set proper command verb host only', ->
      m = "ack 1001 known issue".match(re)
      ca = new commandAck.CommandAck({})
      expect(ca.verb).to.eql "ACKNOWLEDGE_HOST_PROBLEM"

    it 'hostname set', ->
      ca = new commandAck.CommandAck(
        'host.domain.com',
        null,
        'fromHandle'
        )
      ca.interpolate()
      expect(ca.commandArray[1]).to.equal "host.domain.com"


    it 'sticky set', ->
      ca = new commandAck.CommandAck(
        'host.domain.com',
        null,
        'fromHandle'
        )
      ca.interpolate()
      expect(ca.commandArray[2]).to.equal 1


    it 'notify set', ->
      ca = new commandAck.CommandAck(
        'host.domain.com',
        null,
        'fromHandle'
        )
      ca.interpolate()
      expect(ca.commandArray[3]).to.equal 1


    it 'persistent set', ->
      ca = new commandAck.CommandAck(
        'host.domain.com',
        null,
        'fromHandle'
        )
      ca.interpolate()
      expect(ca.commandArray[4]).to.equal 1


    it 'author set', ->
      ca = new commandAck.CommandAck(
        'host.domain.com',
        null,
        'message here'
        'fromHandle'
        )
      ca.interpolate()
      expect(ca.commandArray[5]).to.equal 'fromHandle'


    it 'comment set', ->
      ca = new commandAck.CommandAck(
        'host.domain.com',
        null,
        'message here'
        'fromHandle'
        )
      ca.interpolate()
      expect(ca.commandArray[6]).to.equal 'message here'

    it 'setting full commandString', ->
      ca = new commandAck.CommandAck(
        'host.domain.com',
        null,
        'message here'
        'fromHandle'
        )
      ca.interpolate()
      expect(ca.commandString).to.equal "ACKNOWLEDGE_HOST_PROBLEM;host.domain.com;1;1;1;fromHandle;message here"

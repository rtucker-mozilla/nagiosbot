process.env.HUBOT_MOCK_MKLIVE_STATUS="true"
moment = require('moment');
Helper = require('hubot-test-helper')
helper = new Helper([
  '../scripts/nagiosbot-downtime.coffee',
])

co     = require('co')
expect = require('chai').expect
commandDowntime = require('../scripts/command-downtime.coffee')
re = /.*downtime\s+http:\/\/([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i

describe 'downtime', ->
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

    it 'should set proper command verb host only', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime('testhost.domain.com', null, '1h', 'Test Message', 'username', {})
      expect(cd.verb).to.eql "SCHEDULE_HOST_DOWNTIME"

    it 'should set proper command verb with service', ->
      cd = new commandDowntime.CommandDowntime('testhost.domain.com', 'servicename', '1h', 'Test Message', 'username', {})
      expect(cd.verb).to.eql "SCHEDULE_SVC_DOWNTIME"


    it 'commandArray[0] should match SCHEDULE_HOST_DOWNTIME', ->
      cd = new commandDowntime.CommandDowntime('testhost.domain.com', null, '1h', 'Test Message', 'username', {})
      cd.interpolate()
      expect(cd.commandArray[0]).to.eql 'SCHEDULE_HOST_DOWNTIME'

    it 'commandArray[3] should match \d+', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '1d', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.commandArray[3].match(/\d+/)).to.not.be.null

    it 'commandArray[4] should match \d+', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '1d', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.commandArray[4].match(/\d+/)).to.not.be.null
      
    it 'extractDuration 1d', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '1d', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("1d")).to.equal 86400

    it 'extractDuration 2d', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2d', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("2d")).to.equal 86400 * 2

    it 'extractDuration 1h', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '1h', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("1h")).to.equal 3600

    it 'extractDuration 2h', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2h', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("2h")).to.equal 3600 * 2

    it 'extractDuration 1m', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '1m', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("1m")).to.equal 60

    it 'extractDuration 2m', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2m', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("2m")).to.equal 60 * 2

    it 'extractDuration 1s', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '1s', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("1s")).to.equal 1

    it 'extractDuration 2s', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2s', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.extractDuration("2s")).to.equal 2

    it 'hostname set', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2m', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.commandArray[1]).to.equal "host1.vlan.dc.domain.com"

    it 'duration set', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2m', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.commandArray[6]).to.equal 120

    it 'source set', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2m', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.commandArray[7]).to.equal "fromHandle"

    it 'message set', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2m', 'testing', 'fromHandle', {})
      cd.interpolate()
      expect(cd.commandArray[8]).to.equal "testing"

    it 'commandString', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2m', 'testing', 'fromHandle', {})
      cd.interpolate()
      endDuration = parseInt(cd.timestamp) + 120
      expect(cd.commandString).to.equal "SCHEDULE_HOST_DOWNTIME;host1.vlan.dc.domain.com;" + cd.timestamp + ";" + endDuration + ";1;0;120;fromHandle;testing"

    it 'removes http from hostname', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '2m', 'testing', 'fromHandle', {})
      cd.interpolate()
      endDuration = parseInt(cd.timestamp) + 120
      expect(cd.commandString).to.equal "SCHEDULE_HOST_DOWNTIME;host1.vlan.dc.domain.com;" + cd.timestamp + ";" + endDuration + ";1;0;120;fromHandle;testing"

    it 'setting proper duration', ->
      cd = new commandDowntime.CommandDowntime('host1.vlan.dc.domain.com', null, '1h', 'testing', 'fromHandle', {})
      cd.interpolate()
      endDuration = parseInt(cd.timestamp) + 3600 
      expect(cd.commandString).to.equal "SCHEDULE_HOST_DOWNTIME;host1.vlan.dc.domain.com;" + cd.timestamp + ";" + endDuration + ";1;0;3600;fromHandle;testing"
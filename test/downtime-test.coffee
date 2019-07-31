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

    it 'should set proper unixtimestamp', ->
      cd = new commandDowntime.CommandDowntime({})
      m = moment()
      expect(cd.getTimestamp(m)).to.eql moment().unix()
      
    it 'should set proper command verb host only', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      expect(cd.verb).to.eql "SCHEDULE_HOST_DOWNTIME"

    it 'should set proper command verb with service', ->
      m = "downtime http://host.domain.com:Ping 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      expect(cd.verb).to.eql "SCHEDULE_SVC_DOWNTIME"


    it 'commandArray[0] should match SCHEDULE_HOST_DOWNTIME', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.commandArray[0]).to.eql 'SCHEDULE_HOST_DOWNTIME'

    it 'commandArray[3] should match \d+', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.commandArray[3].match(/\d+/)).to.not.be.null

    it 'commandArray[4] should match \d+', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.commandArray[4].match(/\d+/)).to.not.be.null
      
    it 'extractDuration 1d', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("1d")).to.equal 86400

    it 'extractDuration 2d', ->
      m = "downtime http://host.domain.com 1d message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("2d")).to.equal 86400 * 2

    it 'extractDuration 1h', ->
      m = "downtime http://host.domain.com 1h message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("1h")).to.equal 3600

    it 'extractDuration 2h', ->
      m = "downtime http://host.domain.com 2h message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("2h")).to.equal 3600 * 2

    it 'extractDuration 1m', ->
      m = "downtime http://host.domain.com 1m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("1m")).to.equal 60

    it 'extractDuration 2m', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("2m")).to.equal 60 * 2

    it 'extractDuration 1s', ->
      m = "downtime http://host.domain.com 1m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("1s")).to.equal 1

    it 'extractDuration 2s', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.extractDuration("2s")).to.equal 2

    it 'hostname set', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.commandArray[1]).to.equal "host.domain.com"

    it 'source set', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.commandArray[6]).to.equal "fromHandle"

    it 'message set', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      expect(cd.commandArray[7]).to.equal "message here"

    it 'commandString', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      endDuration = parseInt(cd.timestamp) + 120
      expect(cd.commandString).to.equal "SCHEDULE_HOST_DOWNTIME;host.domain.com;" + cd.timestamp + ";" + endDuration + ";1;0;fromHandle;message here"

    it 'removes http from hostname', ->
      m = "downtime http://host.domain.com 2m message here".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      endDuration = parseInt(cd.timestamp) + 120
      expect(cd.commandString).to.equal "SCHEDULE_HOST_DOWNTIME;host.domain.com;" + cd.timestamp + ";" + endDuration + ";1;0;fromHandle;message here"

    it 'setting proper duration', ->
      m = "downtime http://host1.vlan.dc.domain.com 1h testing".match(re)
      cd = new commandDowntime.CommandDowntime(m, "fromHandle")
      cd.interpolate()
      endDuration = parseInt(cd.timestamp) + 3600 
      expect(cd.commandString).to.equal "SCHEDULE_HOST_DOWNTIME;host1.vlan.dc.domain.com;" + cd.timestamp + ";" + endDuration + ";1;0;fromHandle;testing"
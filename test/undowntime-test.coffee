process.env.HUBOT_MOCK_MKLIVE_STATUS="true"
moment = require('moment');
Helper = require('hubot-test-helper')
helper = new Helper([
  '../scripts/nagiosbot-undowntime.coffee',
])

co     = require('co')
expect = require('chai').expect
commandUndowntime = require('../scripts/command-undowntime.coffee')
re = /.*downtime\s+http:\/\/([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i

describe 'downtime', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)
  afterEach ->
    @room.destroy()


    
  context 'CommandUndowntime class for Host', ->

    beforeEach ->
      @input =  ""

    it 'should set proper downtime_id', ->
      un = new commandUndowntime.CommandUndowntime(44, "fromHandle")
      expect(un.downtime_id).to.eql 44
      
    it 'should set proper source', ->
      un = new commandUndowntime.CommandUndowntime(44, "fromHandle")
      expect(un.source).to.eql "fromHandle"
      
    it 'should interpolate', ->
      un = new commandUndowntime.CommandUndowntime(44, "fromHandle")
      un.interpolate()
      proper = "DEL_HOST_DOWNTIME;44"
      expect(un.commandString).to.eql proper
      
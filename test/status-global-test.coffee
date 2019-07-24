process.env.HUBOT_MOCK_MKLIVE_STATUS="true"
Helper = require('hubot-test-helper')
helper = new Helper([
  '../scripts/nagiosbot-dispatch.coffee',
  '../scripts/nagiosbot-status.coffee',
  '../scripts/nagiosbot-status-global.coffee'
])

co     = require('co')
expect = require('chai').expect

describe 'hello-world', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)
  afterEach ->
    @room.destroy()

  context 'user says hi to hubot', ->
    beforeEach ->
      co =>
        yield @room.user.say 'bob', 'hubot status'

    it 'should reply to user', ->
      response = "```@bob: Hosts Total/Hosts Up/Hosts Warning/Hosts Down\n               2/       2/            0/         0\n  Services Total/      Up/      Warning/      Down\n               2/       2/            0/         0\n```"
      expect(@room.messages).to.eql [
        ['bob',   'hubot status']
        ['hubot', response]
      ]
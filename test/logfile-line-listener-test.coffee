Helper = require('hubot-test-helper')
chai = require 'chai'
axios = require('axios');

expect = chai.expect

helper = new Helper('../scripts/router-notification.coffee')
ls = require '../scripts/livestatus.js'
fs = require('fs')

describe 'logfile post for HOST NOTIFICATION message goes to proper room', ->
  beforeEach ->
    process.env.HUBOT_NOTIFICATION_CHANNELS = "irc:irconly;sysalerts:sysadmins"
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()
    @room.name = "irconly"

  afterEach ->
    @room.destroy()
    delete process.env.HUBOT_NOTIFICATION_CHANNELS

  it 'message ends up in room when posting line and raw is true', ->
    room = @room
    line = "[1563240990] HOST NOTIFICATION: irc;host.domain.com;DOWN;host-notify-by-email;PING CRITICAL - Packet loss = 100%"
    data = {
      line: line,
      raw: true
    }
    axios.post("http://127.0.0.1:8080/notification", data).then (resp) ->
      expect(room.messages).to.eql [
        ['hubot', data.line]
      ]
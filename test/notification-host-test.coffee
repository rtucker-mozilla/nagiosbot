Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect
helper = new Helper('../scripts/nagiosbot-dispatch.coffee')

notification = require '../scripts/notification.coffee'
fs = require 'fs'

describe 'HOST notification', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'extracts timestamp', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    properTimestamp = '1529310603'
    expect(n.timestamp).to.equal(properTimestamp)

  it 'extracts notificationType for HOST NOTIFICATION', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'HOST'
    expect(n.notificationType).to.equal(properValue)

  it 'extracts notificationDestination', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'irc'
    expect(n.notificationDestination).to.equal(properValue)

  it 'extracts hostName', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'reviewboard1.webapp.scl3.mozilla.com'
    expect(n.hostName).to.equal(properValue)

  it 'extracts serviceName', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'DOWNTIMESTART (UP)'
    expect(n.serviceName).to.equal(properValue)

  it 'extracts notificationLevel', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'notify-by-email'
    # expect(n.notificationDestionation).to.equal(properValue)

  it 'extracts message', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'PING OK - Packet loss = 0%, RTA = 0.92 ms'
    expect(n.message).to.equal(properValue)

  it 'interpolates notificationIndex correctly', ->
    line = "[1529310603] HOST NOTIFICATION: irc;reviewboard1.webapp.scl3.mozilla.com;DOWNTIMESTART (UP);host-notify-by-email;PING OK - Packet loss = 0%, RTA = 0.92 ms"
    n = new notification.Notification(line)
    n.parse(line)
    msg = n.getMessage(1000)
    properValue = '[1000] [irc] reviewboard1.webapp.scl3.mozilla.com is DOWNTIMESTART (UP): PING OK - Packet loss = 0%, RTA = 0.92 ms'
    expect(msg).to.equal(properValue)
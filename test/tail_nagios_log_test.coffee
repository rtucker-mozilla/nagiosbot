Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/nagiosbot-dispatch.coffee')
utils = require '../tail_nagios_log/utils'
fs = require('fs')

describe 'tail_nagios_log utils', ->

  it 'not process.env set for NAGIOS_LOGFILE', ->
    path = utils.logFilePath()
    expect(path).to.equal("/var/log/nagios/nagios.log")

  it 'process.env set for', ->
    testpath = "/foo/bar/baz"
    process.env.NAGIOS_LOGFILE = testpath
    path = utils.logFilePath()
    expect(path).to.equal(testpath)

  it 'not process.env set for HUBOT_URL', ->
    path = utils.hubotURL()
    expect(path).to.equal("http://127.0.0.1:8080")

  it 'process.env set for HUBOT_URL', ->
    testpath = "http://192.168.1.1:8000"
    process.env.HUBOT_URL = testpath
    path = utils.hubotURL()
    expect(path).to.equal(testpath)

  it 'host notification should not post for invvalid line', ->
    line = "[1563240990] Blah Blah: notificationgroup;host.domain.com;DOWN;host-notify-by-email;PING CRITICAL - Packet loss = 100%"
    expect(utils.shouldPostLine(line)).to.equal(false)

  it 'host notification should post for valid HOST NOTIFICATION line', ->
    line = "[1563240990] HOST NOTIFICATION: notificationgroup;host.domain.com;DOWN;host-notify-by-email;PING CRITICAL - Packet loss = 100%"
    expect(utils.shouldPostLine(line)).to.equal(true)

  it 'host notification should post for valid SERVICE NOTIFICATION line', ->
    line = "[1563240990] SERVICE NOTIFICATION: notificationgroup;host.domain.com;DOWN;host-notify-by-email;PING CRITICAL - Packet loss = 100%"
    expect(utils.shouldPostLine(line)).to.equal(true)
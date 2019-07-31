Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect
helper = new Helper('../scripts/command.coffee')

cmd = require ('../scripts/command.coffee')
fs = require 'fs'

process.env.HUBOT_NOTIFICATION_CHANNELS = "irc:irconly;sysalerts:sysadmins"

describe 'command execution', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()
    delete process.env.HUBOT_NAGIOS_COMMAND_PATH

  it 'sets default NAGIOS_COMMAND_FILE', ->
    c = new cmd.Command()
    defaultPath = "/var/log/nagios/rw/nagios.cmd"
    delete process.env.HUBOT_NAGIOS_COMMAND_PATH
    expect(c.command_file).to.equal(defaultPath)

  it 'sets overrides NAGIOS_COMMAND_FILE via process.env', ->
    thePath = '/tmp/nagios.cmd'
    process.env.HUBOT_NAGIOS_COMMAND_PATH = thePath
    c = new cmd.Command()
    expect(c.command_file).to.equal(thePath)
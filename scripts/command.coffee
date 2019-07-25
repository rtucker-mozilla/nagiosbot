parser = require '../scripts/status-message-parser.coffee'
util = require 'util'
moment = require 'moment'

statusClassificationEmoji = {
  "UP": ":dot_go-green:",
  "DOWNTIMESTART (UP)": ":dot_go-green:",
  "DOWNTIMEEND (UP)": ":dot_go-green:",
  "DOWN": ":dot_moz-red:",
}

class Command
  constructor: (@commandArray) ->
    @command_file = process.env.HUBOT_NAGIOS_COMMAND_PATH || '/var/log/nagios/rw/nagios.cmd'
    @commandString = ""

  buildCommandString: () ->
    @commandString = @commandArray.join(" ")
    return @commandString

module.exports = {
  Command
}
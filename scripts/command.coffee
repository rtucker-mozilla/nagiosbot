parser = require '../scripts/status-message-parser.coffee'
util = require 'util'
moment = require 'moment'

statusClassificationEmoji = {
  "UP": ":dot_go-green:",
  "DOWNTIMESTART (UP)": ":dot_go-green:",
  "DOWNTIMEEND (UP)": ":dot_go-green:",
  "DOWN": ":dot_moz-red:",
}

module.exports.Command = class Command
  constructor: (@commandArray) ->
    @command_file = process.env.HUBOT_NAGIOS_COMMAND_PATH || '/var/log/nagios/rw/nagios.cmd'
    @commandString = ""

  buildCommandString: () ->
    @commandString = @commandArray.join(" ")
    return @commandString
  
  write: () ->
    wstream = fs.createWriteStream(@command_file)
    return wstream.createWriteStream(@commandString)
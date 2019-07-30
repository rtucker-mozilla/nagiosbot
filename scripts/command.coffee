moment = require('moment')
fs = require("fs")
module.exports.Command = class Command
  constructor: (@commandString) ->
    @command_file = process.env.HUBOT_NAGIOS_COMMAND_PATH || '/var/log/nagios/rw/nagios.cmd'

  execute: () ->
      @finalCommandString = "[" + moment().unix() + "]" + @commandString + "\n"
    try 
      wstream = fs.createWriteStream(@command_file)
      wstream.write(@finalCommandString)
    finally
      return
    
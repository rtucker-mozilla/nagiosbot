# Description:
#   Handle execution of downtime for a host
#
# Notes:
#

commandUndowntime = require('./command-undowntime.coffee')
command = require('./command.coffee')
livestatus = require('./livestatus.js')

module.exports = (robot) ->
  robot.respond /.*undowntime\s+http\:\/\/([^: ]+)$/i, (msg) ->
    livestatus.getHost(msg.match[1]).then (result) ->
      console.log(result)
      if parseInt(result[6])
        user = robot.brain.userForId msg.envelope.user.id
        cd = new commandUndowntime.CommandUndowntime(parseInt(result[6]), user.name)
        cd.interpolate()
        cmd = new command.Command(cd.commandString)
        cmd.execute()
        msg.reply "Downtime for #{msg.match[1]} cancelled"
      else
        msg.reply "No Downtime for #{msg.match[1]} active"
    .catch (error) ->
      msg.reply error


# Description:
#   Handle execution of downtime for a host
#
# Notes:
#

debug = true

commandUndowntime = require('./command-undowntime.coffee')
command = require('./command.coffee')
livestatus = require('./livestatus.js')

module.exports = (robot) ->
  robot.respond /.*undowntime\s+(http\:\/\/)?([^: ]+)(?::(.*))?/i, (msg) ->
    livestatus.getHost(msg.match[2]).then (result) ->
      if debug
        console.log("match": + msg.match)
        console.log("msg.match[2]: " + msg.match[2])

      user = robot.brain.userForId msg.envelope.user.id
      for entry in result.split(/\n/)
        hostName = entry.split(/;/)[0]
        livestatus.downtimesByHost(hostName).then (result) ->
          user = robot.brain.userForId msg.envelope.user.id
          cd = new commandUndowntime.CommandUndowntime(result, user.name)
          cd.interpolate()
          cmd = new command.Command(cd.commandString)
          cmd.execute()
          msg.reply "Downtime for #{hostName} cancelled"
        .catch (error) ->
          msg.reply error

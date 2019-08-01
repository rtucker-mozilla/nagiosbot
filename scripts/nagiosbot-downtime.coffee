# Description:
#   Handle execution of downtime for a host
#
# Notes:
#

utils = require("./utils.coffee")
ss = require("./server-stats.coffee")
smp = require("./status-message-parser.coffee")
commandDowntime = require('./command-downtime.coffee')
command = require('./command.coffee')
livestatus = require('./livestatus.js')

module.exports = (robot) ->
  robot.respond /.*downtime\s+http\:\/\/([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i, (msg) ->
    livestatus.getHost(msg.match[1]).then (result) ->
      user = robot.brain.userForId msg.envelope.user.id
      cd = new commandDowntime.CommandDowntime(msg.match, user.name)
      cd.interpolate()
      cmd = new command.Command(cd.commandString)
      cmd.execute()
      msg.reply "Downtime for #{msg.match[1]} scheduled for #{cd.downtimeInterval}"
    .catch (error) ->
      msg.reply error


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

module.exports = (robot) ->
  robot.respond /.*downtime\s+http\:\/\/([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    cd = new commandDowntime.CommandDowntime(msg.match, user.id)
    cd.interpolate()
    command = new command.Command(cd.commandString)
    command.execute()
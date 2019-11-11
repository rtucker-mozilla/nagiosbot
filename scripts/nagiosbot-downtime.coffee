# Description:
# Commands:
#   hubot downtime <hostname>:<service> <duration> <message> - nagiosbot downtime foo.mozilla.com:Replication 1h updates
#   hubot downtime <hostname> <duration> <message> - nagiosbot downtime foo.mozilla.com 1h kernel update
#

utils = require("./utils.coffee")
ss = require("./server-stats.coffee")
smp = require("./status-message-parser.coffee")
commandDowntime = require('./command-downtime.coffee')
command = require('./command.coffee')
livestatus = require('./livestatus.js')

module.exports = (robot) ->
  robot.respond /downtime\s+(\d+)\s?(.*)?$/i, (msg, user) ->
    msgId = msg.match[1]
    user = robot.brain.userForId msg.envelope.user.id
    notificationObject = robot.brain.get(msgId.toString())
    if notificationObject
      ca = new commandDowntime.CommandDowntime(
        msg.match,
        user.name,
        notificationObject
        )
      ca.interpolate()
      cmd = new command.Command(ca.commandString)
      cmd.execute()

      message = ""
      if notificationObject.serviceName
        message = "Downtiming #{notificationObject.serviceName} on #{notificationObject.hostName}"
      else
        message = "Downtiming all services on #{notificationObject.hostName}"

      msg.reply message
    else
      msg.reply "Unable to find object by index #{msg.match[1]}"



  robot.respond /.*downtime\s+http\:\/\/([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i, (msg) ->
    livestatus.getHost(msg.match[1]).then (result) ->
      user = robot.brain.userForId msg.envelope.user.id
      cd = new commandDowntime.CommandDowntime(msg.match, user.name, null)
      cd.interpolate()
      cmd = new command.Command(cd.commandString)
      cmd.execute()
      msg.reply "Downtime for #{msg.match[1]} scheduled for #{cd.downtimeInterval}"
    .catch (error) ->
      msg.reply error


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
debug = true

module.exports = (robot) ->
  robot.respond /downtime\s+(\d+)\s?(.*)?$/i, (msg, user) ->
    msgId = msg.match[1]
    user = robot.brain.userForId msg.envelope.user.id
    notificationObject = robot.brain.get(msgId.toString())
    if notificationObject
      downtimeIntervalMatch = @match[2].match(/^(\d+)([hdms])/)
      downtimeInterval = @downtimeIntervalMatch[1] + @downtimeIntervalMatch[2]
      message = @match[2].replace(@downtimeInterval, "")
      ca = new commandDowntime.CommandDowntime(
        notificationObject.hostName,
        notificationObject.serviceName,
        downtimeInterval,
        message,
        user.name,
        )
      ca.interpolate()
      cmd = new command.Command(ca.commandString)
      cmd.execute()

      if notificationObject.serviceName
        message = "Downtiming #{notificationObject.serviceName} on #{notificationObject.hostName}"
      else
        message = "Downtiming all services on #{notificationObject.hostName}"

      msg.reply message
    else
      msg.reply "Unable to find object by index #{msg.match[1]}"



  robot.respond /.*downtime\s+(http\:\/\/)?([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)/i, (msg) ->
    if debug
      console.log(msg.match)
    livestatus.getHost(hostName).then (result) ->
      result.split(/\n/).forEach(function(hostString) {
        hostName = hostString.split(/;/)[0]
        if debug
          console.log("result is: " + result)
        serviceName = msg.match[2]
        downtimeInterval = msg.match[4]
        user = robot.brain.userForId msg.envelope.user.id
        cd = new commandDowntime.CommandDowntime(hostName, serviceName, downtimeInterval, msg.match[5], user)
        cd.interpolate()
        cmd = new command.Command(cd.commandString)
        cmd.execute()
        msg.reply "Downtime for #{hostName} scheduled for #{cd.downtimeInterval}"
      .catch (error) ->
        msg.reply error

      });


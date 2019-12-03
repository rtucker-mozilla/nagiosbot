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
  robot.on "downtime-by-index", (payload) ->
    msgId = payload.msgId
    msg = payload.msg
    user = robot.brain.userForId msg.envelope.user.id
    notificationObject = robot.brain.get(msgId.toString())
    if notificationObject
      downtimeIntervalMatch = msg.match[4].match(/^(\d+)([hdms])/)
      downtimeInterval = downtimeIntervalMatch[1] + downtimeIntervalMatch[2]
      message = @match[5].replace(@downtimeInterval, "")
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
    if msg.match[2].match(/\d+/)
      msgId = msg.match[2]
      robot.emit "downtime-by-index", {
        msgId,
        msg
      }
    livestatus.getHost(msg.match[2]).then (result) ->
      for entry in result.split(/\n/)
        hostName = entry.split(/;/)[0]
        if debug
          console.log("result is: " + result)
        serviceName = msg.match[3]
        if serviceName == '*'
          serviceName = null
        downtimeInterval = msg.match[4]
        cd = new commandDowntime.CommandDowntime(hostName, serviceName, downtimeInterval, msg.match[5], user.name)
        cd.interpolate()
        if debug
          console.log(cd.commandString)
        cmd = new command.Command(cd.commandString)
        cmd.execute()
        msg.reply "Downtime for #{hostName} scheduled for #{cd.downtimeInterval}"
    .catch (error) ->
      msg.reply error
# Commands:
#   hubot recheck [1234] - have nagiosbot recheck the service by index number.

commandRecheck = require('./command-recheck.coffee')
command = require('./command.coffee')
ed = require('./extractDuration')
moment = require('moment')

module.exports = (robot) ->
# ack by id index numb er
  robot.respond /recheck\s+(\d+)\s?(.*)?$/i, (msg, user) ->
    msgId = msg.match[1]
    timestampObj = null
    validTimestampDirective = false
    if msg.match[2]
      timestampObj = ed.extractDuration(msg.match[2])
      if timestampObj == 0
        timestampObj = null
      else
        validTimestampDirective = true
        timestampObj = moment().unix() + timestampObj
    user = robot.brain.userForId msg.envelope.user.id
    notificationObject = robot.brain.get(msgId.toString())
    if notificationObject
      ca = new commandRecheck.CommandRecheck(
        notificationObject.hostName,
        notificationObject.serviceName,
        timestampObj
        )
      ca.interpolate()
      cmd = new command.Command(ca.commandString)
      cmd.execute()

      message = ""
      if notificationObject.serviceName
        message = "Rechecking #{notificationObject.serviceName} on #{notificationObject.hostName}"
      else
        message = "Rechecking all services on #{notificationObject.hostName}"

      if validTimestampDirective
        message = message + ' in ' + msg.match[2]
      msg.reply message
    else
      msg.reply "Unable to find object by index #{msg.match[1]}"

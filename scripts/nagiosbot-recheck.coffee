# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

commandRecheck = require('./command-recheck.coffee')
command = require('./command.coffee')
ed = require('./extractDuration')

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
        timestampObj = moment().unit() + timestampObj
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

      msg = ""
      if notificationObject.serviceName
        msg.reply "Rechecking #{notificationObject.serviceName} on #{notificationObject.hostName}"
      else
        msg.reply "Rechecking all services on #{notificationObject.hostName}"

      if validTimestampDirective
        msg.reply msg + ' in ' msg.match[2]
    else
      msg.reply "Unable to find object by index #{msg.match[1]}"

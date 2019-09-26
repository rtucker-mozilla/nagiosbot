# Description:
# Commands:
#   hubot ack <index> <comment> - nagiosbot ack 1234 Known Outage

commandAck = require('./command-ack.coffee')
command = require('./command.coffee')
module.exports = (robot) ->
# ack by id index numb er
  robot.respond /ack\s+(\d+)\s?(.*)?$/i, (msg, user) ->
    msgId = msg.match[1]
    comment = msg.match[2]
    console.log(msgId)
    if !comment or comment == ""
      msg.reply "usage: ack <index> <comment>"
      return
    user = robot.brain.userForId msg.envelope.user.id
    notificationObject = robot.brain.get(msgId.toString())
    if notificationObject
      console.log(notificationObject)
      
      ca = new commandAck.CommandAck(
        notificationObject.hostName,
        notificationObject.serviceName,
        comment,
        user.name
        )
      ca.interpolate()
      cmd = new command.Command(ca.commandString)
      cmd.execute()
      msg.reply "Notification for #{msg.match[1]} acked"
    else
      msg.reply "Unable to find object by index #{msg.match[1]}"

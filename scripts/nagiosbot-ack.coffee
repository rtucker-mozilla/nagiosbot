# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

commandAck = require('./command-ack.coffee')
command = require('./command.coffee')
module.exports = (robot) ->
# ack by id index numb er
  robot.respond /ack\s+(\d+)\s?(.*)?$/i, (msg, user) ->
    console.log("asfasfasdfasdfsadfasdfasdfas fasdfkasfd hkjasfd hkjsadf hkjlasfk jhasf kjasfhkjlasf hkas")
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

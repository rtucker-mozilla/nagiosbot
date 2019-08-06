# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

utils = require("./utils.coffee")
ss = require("./server-stats.coffee")
smp = require("./status-message-parser.coffee")
module.exports = (robot) ->
# ack by id index numb er
  robot.respond /ack\s+(\d+)$/i, (msg, user) ->
    console.log("msg.match: " + msg.match)
    msgId = msg.match[1]
    notificationObject = robot.brain.get(msgId.toString())
    console.log(notificationObject)
    msg.reply "Acking"
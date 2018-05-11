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
livestatus = require("./livestatus.js")
leftPad = require("left-pad")
smp = require("./status-message-parser.coffee")
module.exports = (robot) ->
  #
  # here is the entrypoint router
  # we want to be adapter agnostic and there are
  # different syntaxes for robot naming across IRC and Slack
  #
  # start by removing the robot name and then emitting to the
  # proper endpoint
  #

  robot.on "status", (msg, user) ->
    messageText = utils.removeName(robot, msg.message.text)
    room = msg.envelope.room
    if utils.actionIndex("status", messageText) == 0
      statusMessageObject = smp.parse(messageText)
      robot.emit statusMessageObject.emitCode, statusMessageObject, user, room

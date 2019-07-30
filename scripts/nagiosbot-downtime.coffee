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
commandDowntime = require('../scripts/command-downtime.coffee')
command = require('../scripts/command.coffee')

module.exports = (robot) ->
  #
  # here is the entrypoint router
  # we want to be adapter agnostic and there are
  # different syntaxes for robot naming across IRC and Slack
  #
  # start by removing the robot name and then emitting to the
  # proper endpoint
  #

module.exports = (robot) ->
  robot.respond /.*downtime\s+([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    msg.reply "Downtime for #{msg.match[1]} scheduled for 1 day"
    cd = new commandDowntime.CommandDowntime(msg.match, user.id)
    cd.interpolate()
    c = new command.Command(cd.commandString)
    c.execute()
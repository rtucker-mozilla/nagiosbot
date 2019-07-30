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
commandDowntime = require('./command-downtime.coffee')
command = require('./command.coffee')

module.exports = (robot) ->
  robot.respond /.*downtime\s+([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    tmp = msg.match
    tmp[1] = tmp[1].replace(/http\:\/\//,"")

    cd = new commandDowntime.CommandDowntime(tmp, user.id)
    cd.interpolate()
    msg.reply "match #{msg.match}"
    msg.reply "Downtime for #{msg.match[1]} scheduled for 1 day"
    cmd = new command.Command(cd.commandString)
    cmd.execute()
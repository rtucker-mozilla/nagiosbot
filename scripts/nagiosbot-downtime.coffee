utils = require("./utils.coffee")
ss = require("./server-stats.coffee")
smp = require("./status-message-parser.coffee")
commandDowntime = require('./command-downtime.coffee')
command = require('./command.coffee')

module.exports = (robot) ->
  robot.respond /.*downtime\s+([^: ]+)(?::(.*))?\s+(\d+[dhms])\s+(.*)\s*/i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    tmp = msg.match
    tmp[1] = tmp[1].replace(/http\:\/\//, "")

    cd = new commandDowntime.CommandDowntime(tmp, user.id)
    cd.interpolate()
    msg.reply "match #{tmp}"
    msg.reply "Downtime for #{tmp[1]} scheduled for 1 day"
    command = new command.Command(cd.commandString)
    command.execute()
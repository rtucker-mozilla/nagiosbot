# Description:
#   main entry point for disaptch to modules
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.respond /status/i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    console.log(msg.message.text)
    robot.emit "status", msg, user.name

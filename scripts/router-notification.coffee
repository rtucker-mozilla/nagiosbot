# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

notification = require '../scripts/notification.coffee'
notificationIndex = require '../scripts/notification-index.coffee'
module.exports = (robot) ->

  # global status output
  robot.router.post "/notification/create", (request, res) ->
    # @TODO: Need to pull room mapping from json config file
    room = "#nagiosbot"
    payload = request.body.payload
    start = process.env.HUBOT_INDEX_START || 1000
    width = process.env.HUBOT_INDEX_WIDTH || 100
    ni = new notificationIndex.NotificationIndex(robot, start, width)
    n = new notification.Notification(payload)
    n.parse()
    nextIndex = ni.getNextIndex()
    msg = n.getMessage(nextIndex)
    robot.messageRoom room, msg
    ni.set(n)
    console.log("From Brain: " + robot.brain.get('1000'))
    res.end "Notification Received: " + nextIndex
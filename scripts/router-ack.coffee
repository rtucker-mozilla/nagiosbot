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
  robot.router.post "/ack", (request, res) ->
    # @TODO: Need to pull room mapping from json config file
    data   = if request.body.payload? then JSON.parse request.body.payload else request.body
    start = process.env.HUBOT_INDEX_START || 1000
    width = process.env.HUBOT_INDEX_WIDTH || 100
    console.log("ack received")
    console.log(data.line)
    matchRe = /^\[(\d+)\]\s(SERVICE|HOST)\sNOTIFICATION:\s([^;]+);([^;]+);([^;]+);([^;]+);([^;]+).*/
    ni = new notificationIndex.NotificationIndex(robot, start, width)
    n = new notification.Notification(data.line)
    n.parse()
    currentIndex = ni.currentIndex
    msg = n.getMessage(currentIndex)
    if data.raw
      robot.messageRoom n.notificationChannel, data.line
    else
      robot.messageRoom n.notificationChannel, msg
    ni.set(n)
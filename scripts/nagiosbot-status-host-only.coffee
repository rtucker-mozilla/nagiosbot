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
module.exports = (robot) ->

  # global status output
  robot.on "status:host", (messageObject, user, room) ->
    if process.env.HUBOT_USE_MKLIVE_STATUS=="true"
      hostQueryArray = [
        "GET hosts",
        "Columns: host_name state plugin_output last_check host_acknowledged address",
        "Filter: host_name ~ " + livestatus.buildWildcardQuery(messageObject.hostName)
      ]
      hostQuery = hostQueryArray.join("\n") + "\n\n"
      livestatus.executeQuery process.env.HUBOT_LIVESTATUS_SOCKET_PATH, hostQuery, (data) =>
        hostResponse = data
        robot.emit 'slack-attachment',
          channel: room
          username: robot.name
          icon_url: "https://slack.global.ssl.fastly.net/9fa2/img/services/hubot_128.png"
          content:
            fallback: "fallback"
            title: "Nagios Host Status"
            title_link: "https://github.com"
            text: hostResponse
            image_url: "https://assets-cdn.github.com/images/modules/logos_page/GitHub-Logo.png"
            color: "#111111"
# robot.messageRoom room, hostResponse

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

  # global status output
  robot.on "status:service", (messageObject, user, room) ->
    if process.env.HUBOT_USE_MKLIVE_STATUS=="true"
      hostQueryArray = [
        "GET services",
        "Columns: host_name state plugin_output last_check service_acknowledged description",
        "Filter: description ~~ " + messageObject.serviceNameSearch,
        "Filter: host_name ~~ " + messageObject.hostNameSearch
      ]
      hostQuery = hostQueryArray.join("\n") + "\n\n"
      console.log('hostQuery: ' + hostQuery)
      livestatus.executeQuery(hostQuery).then (data) ->
        hostResponse = data
        console.log('data: ' + data)
        resp = new smp.StatusMessageParser(data)
        if robot.adapterName == "slack"
          if data
            msgData = {
              channel: room
              attachments: [
                {
                  fallback: "Service Status Response",
                  title: "Service Status Response",
                  title_link: "View Status",
                  text:  resp.formattedResponse(),
                  mrkdwn_in: ["text"]
                }
              ]
            }
            robot.messageRoom room, msgData
          else
            robot.messageRoom room, "No Results Found"
            

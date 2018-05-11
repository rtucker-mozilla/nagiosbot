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
  robot.on "status:global", (messageObject, user, room) ->
    if process.env.HUBOT_USE_MKLIVE_STATUS=="true"
      hostQuery = "GET hosts\nColumns: host_name state plugin_output last_check host_acknowledged address\n\n"
      serviceQuery = "GET services\nColumns: host_name state plugin_output last_check service_acknowledged description\n\n"
      livestatus.executeQuery process.env.HUBOT_LIVESTATUS_SOCKET_PATH, hostQuery, (data) =>
        hostResponse = data
        livestatus.executeQuery process.env.HUBOT_LIVESTATUS_SOCKET_PATH, serviceQuery, (serviceData) =>
          serviceResponse = serviceData
          totalHosts = ss.livestatusHostsCount(hostResponse)
          hostsUp = ss.livestatusHostsUpCount(hostResponse)
          hostsWarning = ss.livestatusHostsWarningCount(hostResponse)
          hostsDown = ss.livestatusHostsDownCount(hostResponse)
          totalServices = ss.livestatusServicesCount(serviceResponse)
          servicesUp = ss.livestatusServicesUpCount(serviceResponse)
          servicesWarning = ss.livestatusServicesWarningCount(serviceResponse)
          servicesDown = ss.livestatusServicesDownCount(serviceResponse)

          paddingLength = user.length + 2
          hostsHeader = [
            "Hosts Total",
            "Hosts Up",
            "Hosts Warning",
            "Hosts Down",
          ]
          servicesHeader = [
            "Services Total",
            "      Up",
            "      Warning",
            "      Down",
          ]
          message = "#{user}: " + hostsHeader.join("/") + "\n"
          message = message + " ".repeat(paddingLength) + "#{utils.padToMatchLength(hostsHeader[0],totalHosts)}/#{utils.padToMatchLength(hostsHeader[1],hostsUp)}/#{utils.padToMatchLength(hostsHeader[2], hostsWarning)}/#{utils.padToMatchLength(hostsHeader[3], hostsDown)}\n"
          message = message + " ".repeat(paddingLength - 3) + servicesHeader.join("/") + "\n"
          message = message + " ".repeat(paddingLength) + "#{utils.padToMatchLength(servicesHeader[0],totalServices, offset=-3)}/#{utils.padToMatchLength(servicesHeader[1],servicesUp)}/#{utils.padToMatchLength(servicesHeader[2], servicesWarning)}/#{utils.padToMatchLength(servicesHeader[3], servicesDown)}\n"
          message = "```" + message + "```"
          robot.messageRoom room, message

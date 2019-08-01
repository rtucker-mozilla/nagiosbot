moment = require('moment')
livestatus = require('./livestatus.js')

module.exports.CommandBaseClass = class CommandBaseClass
  getTimestamp: () ->
    return moment().unix()

  fixHostname: (hostname) ->
    if hostname
      return hostname.replace(/^http\:\/\//, "")
    else
      return ""

  getHost: (hostname) ->
      livestatus.getHost(messageObject.hostName).then (result) ->
          return result
      .catch (error) ->
        return false
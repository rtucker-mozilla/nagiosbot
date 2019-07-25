parser = require '../scripts/status-message-parser.coffee'
util = require 'util'
moment = require 'moment'

statusClassificationEmoji = {
  "UP": ":dot_go-green:",
  "DOWNTIMESTART (UP)": ":dot_go-green:",
  "DOWNTIMEEND (UP)": ":dot_go-green:",
  "DOWN": ":dot_moz-red:",
}

exports.Notification = class Notification
  constructor: (@line) ->

  segmentByDelimeter: (input, delimeter, index) ->
    return input.split(delimeter)[index]

  formatDate: (timestamp) ->
    dateObj = moment(timestamp * 1000)
    return dateObj.format('ddd HH:mm:ss UTC')

  getMessage: (index) ->
    return util.format('%s %s [%d] [%s] %s is %s: %s', @emoji, @dateFormat, index, @notificationDestination, @hostName, @serviceName, @message)

  parse: ->
    hostOrServiceRe = /^\[\d+\]\s(SERVICE|HOST)\sNOTIFICATION:.*/
    hostOrServiceMatches = @line.match(hostOrServiceRe)
    processNotificationChannels = process.env.HUBOT_NOTIFICATION_CHANNELS || ""
    tmp = {}
    for element in processNotificationChannels.split(";")
      name = element.split(":")[0] || ""
      value = element.split(":")[1] || ""
      tmp[name] = value
    @notificationChannels = tmp

    if hostOrServiceMatches[1] == 'HOST'
      matchRe = /^\[(\d+)\]\s(SERVICE|HOST)\sNOTIFICATION:\s([^;]+);([^;]+);([^;]+);([^;]+);([^;]+).*/
      matches = @line.match(matchRe)
      @timestamp = matches[1]
      @notificationType = matches[2]
      @notificationDestination = matches[3]
      @hostName = matches[4]
      @serviceName = matches[5]
      @notificationAction = matches[6]
      @message = matches[7]
      @emoji = statusClassificationEmoji[@serviceName]
      @dateFormat = this.formatDate(@timestamp)

    else
      matchRe = /^\[(\d+)\]\s(SERVICE|HOST)\sNOTIFICATION:\s([^;]+);([^;]+);([^;]+);([^;]+);([^;]+);([^;]+).*/
      matches = @line.match(matchRe)
      @timestamp = matches[1]
      @notificationType = matches[2]
      @notificationDestination = matches[3]
      @hostName = matches[4]
      @serviceName = matches[5]
      @notificationLevel = matches[6]
      @notificationAction = matches[7]
      @message = matches[8]
      @emoji = statusClassificationEmoji[@serviceName]
      @dateFormat = this.formatDate(@timestamp)

    @notificationChannel = @notificationChannels[@notificationDestination] || @notificationDestination
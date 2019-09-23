parser = require '../scripts/status-message-parser.coffee'
util = require 'util'
moment = require 'moment'

statusClassificationEmoji = {
  "UP": ":nagios_status_ok_green:",
  "DOWNTIMESTART (UP)": ":nagios_status_ok_green:",
  "DOWNTIMEEND (UP)": ":nagios_status_ok_green:",
  "ACKNOWLEDGEMENT (CRITICAL)": ":nagios_status_critical_red:",
  "ACKNOWLEDGEMENT (WARNING)": ":nagios_status_warning_yellow:",
  "ACKNOWLEDGEMENT (OK)": ":nagios_status_ok_green:",
  "DOWN": ":nagios_status_critical_red:",
  "CRITICAL": ":nagios_status_critical_red:",
  "OK": ":nagios_status_ok_green:",
  "WARNING": ":nagios_status_warning_yellow:",
}

exports.Notification = class Notification
  constructor: (@line) ->

  segmentByDelimeter: (input, delimeter, index) ->
    return input.split(delimeter)[index]

  formatDate: (timestamp) ->
    dateObj = moment(timestamp * 1000)
    return dateObj.format('ddd HH:mm:ss UTC')

  getMessage: (index) ->
    if @notificationType == "HOST"
      return util.format('%s %s [%d] [%s] HOST %s is %s', @emoji, @dateFormat, index, @notificationDestination, @hostName, @message)
    else if @notificationType == "SERVICE"
      return util.format('%s %s [%d] [%s] %s:%s is %s %s', @emoji, @dateFormat, index, @notificationDestination, @hostName, @serviceName, @notificationLevel, @message)

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
      @serviceName = null
      @notificationLevel = matches[5]
      @notificationAction = matches[6]
      @message = matches[7]
      @emoji = statusClassificationEmoji[@notificationLevel]
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
      @emoji = statusClassificationEmoji[@notificationLevel]
      @dateFormat = this.formatDate(@timestamp)

    @notificationChannel = @notificationChannels[@notificationDestination] || @notificationDestination
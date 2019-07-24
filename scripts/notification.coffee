parser = require '../scripts/status-message-parser.coffee'
util = require 'util'

exports.Notification = class Notification
  constructor: (@line) ->

  segmentByDelimeter: (input, delimeter, index) ->
    return input.split(delimeter)[index]

  getMessage: (index) ->
    return util.format('%s [%d] [%s] %s is %s: %s', @emoji, index, @notificationDestination, @hostName, @serviceName, @message)

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
      if @serviceName == 'DOWN'
        @emoji = ':dot_moz-red:'
      else if @serviceName == 'UP'
        @emoji = ':dot_go-green:'
      else
        @emoji = ''

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

    @notificationChannel = @notificationChannels[@notificationDestination] || @notificationDestination
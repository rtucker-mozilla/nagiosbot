parser = require '../scripts/status-message-parser.coffee'
util = require 'util'

exports.Notification = class Notification
  constructor: (@line) ->

  segmentByDelimeter: (input, delimeter, index) ->
    return input.split(delimeter)[index]

  getMessage: (index) ->
    return util.format('[%d] [%s] %s is %s: %s', index, @notificationDestination, @hostName, @serviceName, @message)

  parse: ->
    hostOrServiceRe = /^\[\d+\]\s(SERVICE|HOST)\sNOTIFICATION:.*/
    hostOrServiceMatches = @line.match(hostOrServiceRe)
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

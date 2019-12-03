moment = require('moment')
livestatus = require('./livestatus.js')
base = require('./base.coffee')
ed = require('./extractDuration')

debug = true
module.exports.CommandDowntime = class CommandDowntime extends base.CommandBaseClass
  constructor: (@hostname, @serviceName, @downtimeInterval, @message, @source, @notificationObject) ->
    @commandArray = []
    @hostname = @fixHostname(@hostname)

    if @serviceName
      @verb = "SCHEDULE_SVC_DOWNTIME"
    else
      @verb = "SCHEDULE_HOST_DOWNTIME"

  extractDuration: (inputDuration) ->
    return ed.extractDuration(inputDuration)

  calculateDuration: (baseTimestamp, additionalSeconds) ->
    baseTimestamp = parseInt(baseTimestamp)
    additionalSeconds = parseInt(additionalSeconds)
    return baseTimestamp + additionalSeconds

  interpolate: () ->
    # write_string = "[%lu] SCHEDULE_HOST_DOWNTIME;hostname;timestamp;timestamp + duration;1;0;%d;%s;%s" % (int(time.time()), host, int(time.time()), int(time.time()) + duration, duration, event.source, comment)
    @timestamp = @getTimestamp()
    duration = @extractDuration(@downtimeInterval)
    if @serviceName
      @commandArray[0] = @verb
      @commandArray[1] = @hostname
      @commandArray[2] = @serviceName
      @commandArray[3] = @timestamp.toString()
      @commandArray[4] = @calculateDuration(@timestamp, duration).toString()
      @commandArray[5] = "1"
      @commandArray[6] = "0"
      @commandArray[7] = duration
      @commandArray[8] = @source
      @commandArray[9] = @message
    else
      @commandArray[0] = @verb
      @commandArray[1] = @hostname
      @commandArray[2] = @timestamp.toString()
      @commandArray[3] = @calculateDuration(@timestamp, duration).toString()
      @commandArray[4] = "1"
      @commandArray[5] = "0"
      @commandArray[6] = duration
      @commandArray[7] = @source
      @commandArray[8] = @message
    @buildCommandString()

  buildCommandString: () ->
    @commandString = @commandArray.join(";")
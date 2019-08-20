moment = require('moment')
livestatus = require('./livestatus.js')
base = require('./base.coffee')
ed = require('./extractDuration')


module.exports.CommandDowntime = class CommandDowntime extends base.CommandBaseClass
  constructor: (@match, @source) ->
    @commandArray = []
    @hostname = @fixHostname(@match[1])
    @downtimeInterval = ""
    if @match[2]?
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
    @downtimeInterval = @match[3]
    duration = @extractDuration(@downtimeInterval)
    @commandArray[0] = @verb
    @commandArray[1] = @hostname
    @commandArray[2] = @timestamp.toString()
    @commandArray[3] = @calculateDuration(@timestamp, duration).toString()
    @commandArray[4] = "1"
    @commandArray[5] = "0"
    @commandArray[6] = duration
    @commandArray[7] = @source
    @commandArray[8] = @match[4]
    @buildCommandString()

  buildCommandString: () ->
    @commandString = @commandArray.join(";")
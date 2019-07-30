moment = require('moment');
cmd = require('./cmd.coffee')

class CommandBaseClass
  getTimestamp: () ->
    return moment().unix()


module.exports.CommandDowntime = class CommandDowntime extends CommandBaseClass
  constructor: (@match, @source) ->
    @commandArray = []
    @hostname = @match[1]
    @downtimeInterval = ""
    if @match[2]?
      @verb = "SCHEDULE_SVC_DOWNTIME"
    else
      @verb = "SCHEDULE_HOST_DOWNTIME"

  extractDuration: (inputDuration) ->
    m = inputDuration.match(/^(\d+)([hdms])/)
    retVal = 0
    switch m[2]
      when "d" then retVal = parseInt(m[1]) * 86400
      when "h" then retVal = parseInt(m[1]) * 3600
      when "m" then retVal = parseInt(m[1]) * 60
      when "s" then retVal = parseInt(m[1])
      else retVal = 0
    return parseInt(retVal)

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
    @commandArray[6] = @source
    @commandArray[7] = @match[4]
    @buildCommandString()

  buildCommandString: () ->
    @commandString = @commandArray.join(";")
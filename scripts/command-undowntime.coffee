moment = require('moment')
livestatus = require('./livestatus.js')
base = require('./base.coffee')

module.exports.CommandUndowntime = class CommandUndowntime extends base.CommandBaseClass
  constructor: (@downtime_id, @source) ->
    @commandArray = []
    @verb = "DEL_HOST_DOWNTIME"

  interpolate: () ->
    # write_string = "DEL_HOST_DOWNTIME;<downtime_id>"
    @commandArray[0] = @verb
    @commandArray[1] = @downtime_id
    @buildCommandString()

  buildCommandString: () ->
    @commandString = @commandArray.join(";")
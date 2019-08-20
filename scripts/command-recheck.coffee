moment = require('moment')
livestatus = require('./livestatus.js')
base = require('./base.coffee')

# https://assets.nagios.com/downloads/nagioscore/docs/externalcmds/cmdinfo.php?command_id=39

module.exports.CommandRecheck = class CommandRecheck extends base.CommandBaseClass
  constructor: (@hostname, @service, @check_time) ->
    if !@check_time
      @check_time = moment().unix()
    @commandArray = []
    if @service
      @verb = "SCHEDULE_FORCED_SVC_CHECK"
    else
      @verb = "SCHEDULE_FORCED_HOST_CHECK"

  interpolate: () ->
    # write_string = "ACKNOWLEDGE_HOST_PROBLEM;<host_name>;<sticky>;<notify>;<persistent>;<author>;<comment>"
    # write_string = "[%lu] ACKNOWLEDGE_HOST_PROBLEM;%s;1;1;1;nagiosadmin;(%s)%s\n" % (timestamp,host,from_user,message)

    if @service

      @commandArray[0] = @verb
      @commandArray[1] = @hostname
      @commandArray[2] = @service
      @commandArray[3] = @check_time
    else
      @commandArray[0] = @verb
      @commandArray[1] = @hostname
      @commandArray[2] = @check_time
    @buildCommandString()

  buildCommandString: () ->
    @commandString = @commandArray.join(";")
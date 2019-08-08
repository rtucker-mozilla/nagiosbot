moment = require('moment')
livestatus = require('./livestatus.js')
base = require('./base.coffee')

# https://assets.nagios.com/downloads/nagioscore/docs/externalcmds/cmdinfo.php?command_id=39

module.exports.CommandAck = class CommandAck extends base.CommandBaseClass
  constructor: (@hostname, @service, @comment, @source) ->
    @commandArray = []
    @verb = "ACKNOWLEDGE_HOST_PROBLEM"
    @sticky = 1
    @notify = 1
    @persistent = 1

  interpolate: () ->
    # write_string = "ACKNOWLEDGE_HOST_PROBLEM;<host_name>;<sticky>;<notify>;<persistent>;<author>;<comment>"
    # write_string = "[%lu] ACKNOWLEDGE_HOST_PROBLEM;%s;1;1;1;nagiosadmin;(%s)%s\n" % (timestamp,host,from_user,message)

    @commandArray[0] = @verb
    @commandArray[1] = @hostname
    @commandArray[2] = @sticky
    @commandArray[3] = @notify
    @commandArray[4] = @persistent
    @commandArray[5] = @source
    @commandArray[6] = @comment
    @buildCommandString()

  buildCommandString: () ->
    @commandString = @commandArray.join(";")
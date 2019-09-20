strftime = require('strftime')
moment = require('moment')

statuses = {
  0 : {
    'Text': 'OK'
  },
  1 : {
    'Text': 'WARNING'
  },
  2 : {
    'Text': 'CRITICAL'
  },
  3 : {
    'Text': 'UNKNOWN'
  },
}
module.exports.notificationIdFromMessage = (message) ->
  match = message.match(/status\s+(\d+)/)
  if match
    return parseInt(match[1])
  return null

module.exports.shouldGetFromBrain = (message) ->
  if message.match(/status\s+\d+/)
    return true
  else
    return false

module.exports.fixHostnames = (message) ->
  # slack appends http:// in front of hostnames
  # work around it

  if message.match(/status\s+http\:\/\//)
    message = message.replace(/status http\:\/\//, "status ")
  else if message.match(/status\s+\*\.http\:\/\//)
    message = message.replace(/status\s+\*\.http\:\/\//, "status *.")
  else if message.match(/status\s+[\*]http\:\/\//)
    message = message.replace(/status\s+\*http\:\/\//, "status *")
  else
    message = message.replace("status http://", "status ")
  return message

module.exports.parse = (message) ->
  message = module.exports.fixHostnames(message)


  ret = {}
  ret.hostName = ""
  ret.hostNameSearch = ""
  ret.serviceName = ""
  ret.serviceNameSearch = ""
  ret.hostOnly = false
  ret.hasService = false
  ret.serviceWildcard = false
  ret.hostNameWildcard = false
  ret.emitCode = ""
  ret.message = message
  if message == "status"
    ret.emitCode = "status:global"
    return ret
  serviceRegex = /^status[\s\:]+(.*):(.*)/
  hostOnlyRegex = /^status[\s\:]+(.*)/
  if match = message.match(serviceRegex)
    ret.hasService = true
    ret.hostName = match[1]
    if ret.hostName.includes('*')
      ret.hostNameWildcard = true
      if ret.hostName.startsWith('*')
        ret.hostNameSearch = ret.hostName.replace(/^\*/,'')
      if !ret.hostName.endsWith('*')
        ret.hostNameSearch = ret.hostNameSearch + '$'
    else
      ret.hostNameSearch = '^' + ret.hostName + '$'
    ret.serviceName = match[2]

    if ret.serviceName.includes('*')
      ret.serviceNameWildcard = true
      if ret.serviceName.startsWith('*')
        ret.serviceNameSearch = ret.serviceName.replace(/^\*/,'')
      else
        ret.serviceNameSearch = '^' + ret.serviceName
      if ret.serviceName.endsWith('*')
        ret.serviceNameSearch = ret.serviceNameSearch.replace(/\*$/,'')
      else
        ret.serviceNameSearch = ret.serviceNameSearch + '$'
    else
      ret.serviceNameSearch = '^' + ret.serviceName + '$'
     
    ret.emitCode = "status:service"
    if ret.serviceName == "*"
      ret.serviceWildcard = true
  else if match = message.match(hostOnlyRegex)
    ret.hostOnly = true
    ret.hostName = match[1].replace("http://", "")
    if ret.hostName.includes('*')
      ret.hostNameWildcard = true
      if ret.hostName.startsWith('*')
        ret.hostNameSearch = ret.hostName.replace(/^\*/,'')
    ret.emitCode = "status:host"
  return ret

module.exports.splitResponse = (response) ->
  ret = []
  for line in response.split("\n")
    if line.length > 1
      ret.push(line)
  return ret

module.exports.segmentByDelimeter = (input, delimeter, index) ->
  return input.split(delimeter)[index]

module.exports.hostNameByLine = (line) -> 
  return module.exports.segmentByDelimeter(line, ';', 0)

module.exports.serviceNameByLine = (line) -> 
  return module.exports.segmentByDelimeter(line, ';', 2)

module.exports.hostNameByLine = (line) -> 
  return module.exports.segmentByDelimeter(line, ';', 0)


module.exports.statusDescriptionByLine = (line) ->
  statusInteger = module.exports.statusIntegerByLine line
  return statuses[statusInteger].Text
    

module.exports.formatStatusResponse = (response) ->
  @lines = module.exports.splitResponse(response)

exports.StatusMessageParser = class StatusMessageParser
  constructor: (@response) ->

  parse: ->
    @splitResponse()

  splitResponse: ->
    ret = []
    for line in @response.split("\n")
      if line.length > 1
        ret.push(line)
    @lines = ret
    return ret

  formattedResponse: ->
    ret = []
    for line in @splitResponse()
      tmp = new StatusMessageLineParser(line)
      ret.push(tmp.formattedResponse())
    ret.join("\n")

exports.StatusMessageLineParser = class StatusMessageLineParser
  constructor: (@line) ->

  segmentByDelimeter: (input, delimeter, index) ->
    return input.split(delimeter)[index]

  formattedResponse: ->
    @parse()
    if @serviceName
      addLine = "#{@hostName}:#{@serviceName} is #{@statusText} - #{@serviceDescription} - Last Checked #{@lastChecked}"
    else
      addLine = "#{@hostName} is #{@statusText} - #{@serviceDescription} - Last Checked #{@lastChecked}"
    if process.env.HUBOT_OK_EMOJI
      try
        addLine = process.env['HUBOT_' + @statusText + '_EMOJI'] + ' ' + addLine
      catch
    return addLine

  parse: ->
    @serviceDescription = @segmentByDelimeter @line, ';', 2
    statusIntStr = @segmentByDelimeter @line, ';', 1
    @statusInt = parseInt statusIntStr
    @statusText = statuses[@statusInt].Text
    @hostName = @segmentByDelimeter @line, ';', 0
    lastCheckedInt = @segmentByDelimeter @line, ';', 3
    lastCheckedInt = parseInt(lastCheckedInt)
    @lastChecked = moment.unix(lastCheckedInt).utc().format('YYYY-MM-DD HH:mm:ss UTC')
    @serviceName = @segmentByDelimeter @line, ';', 5
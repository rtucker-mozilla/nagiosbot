module.exports.parse = (message) ->
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

  ret = {}
  ret.hostName = ""
  ret.serviceName = ""
  ret.hostOnly = false
  ret.hasService = false
  ret.serviceWildcard = false
  ret.emitCode = ""
  ret.message = message
  if message == "status"
    ret.emitCode = "status:global"
    return ret
  serviceRegex = /^status[\s:]+(.*[^\:])+:(.*)$/
  hostOnlyRegex = /^status[\s:]+(.*)/
  if match = message.match(serviceRegex)
    ret.hasService = true
    ret.hostName = match[1]
    ret.serviceName = match[2]
    ret.emitCode = "status:service"
    if ret.serviceName == "*"
      ret.serviceWildcard = true
  else if match = message.match(hostOnlyRegex)
    ret.hostOnly = true
    ret.hostName = match[1].replace("http://", "")
    ret.emitCode = "status:host"
  return ret

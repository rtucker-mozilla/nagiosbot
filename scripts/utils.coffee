module.exports.removeName = (robot, message) ->
  replaceString = "^[@]?#{robot.name}[\s:]?"
  re = new RegExp(replaceString)
  message = message.replace(re,"").trim()
  return message

module.exports.actionIndex = (needle, haystack) ->
  counter = 0
  for i in haystack.split(' ')
    if i == needle
      return counter
    counter++
  false

module.exports.padToMatchLength = (longString, shortString) ->
  lengthDiff = longString.length - shortString.toString().length
  " ".repeat(lengthDiff) + shortString

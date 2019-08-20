module.exports.extractDuration = (inputDuration) ->
  m = inputDuration.match(/^(\d+)([hdms])/)
  retVal = 0
  switch m[2]
    when "d" then retVal = parseInt(m[1]) * 86400
    when "h" then retVal = parseInt(m[1]) * 3600
    when "m" then retVal = parseInt(m[1]) * 60
    when "s" then retVal = parseInt(m[1])
    else retVal = 0
  return parseInt(retVal)
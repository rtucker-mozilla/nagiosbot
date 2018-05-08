DELIMETER=";"
HOST_STATUS_COLUMN_INDEX=1
SERVICE_STATUS_COLUMN_INDEX=1
UP_INT=0
WARNING_INT=1
DOWN_INT=2

module.exports.livestatusHostsCount = (data) ->
  return module.exports.countLines data

module.exports.livestatusServicesCount = (data) ->
  return module.exports.countLines data

module.exports.livestatusHostsWarningCount = (data) ->
  return module.exports.countByColumnIndex(data,HOST_STATUS_COLUMN_INDEX,WARNING_INT)

module.exports.livestatusHostsDownCount = (data) ->
  return module.exports.countByColumnIndex(data,HOST_STATUS_COLUMN_INDEX,DOWN_INT)

module.exports.livestatusHostsUpCount = (data) ->
  return module.exports.countByColumnIndex(data,HOST_STATUS_COLUMN_INDEX,UP_INT)

module.exports.livestatusServicesUpCount = (data) ->
  return module.exports.countByColumnIndex(data,SERVICE_STATUS_COLUMN_INDEX,UP_INT)

module.exports.livestatusServicesWarningCount = (data) ->
  return module.exports.countByColumnIndex(data,SERVICE_STATUS_COLUMN_INDEX,WARNING_INT)

module.exports.livestatusServicesDownCount = (data) ->
  return module.exports.countByColumnIndex(data,SERVICE_STATUS_COLUMN_INDEX,DOWN_INT)

module.exports.countLines = (data) ->
  # one option is to just take the length of the a
  # it is also possible that we should loop over and count
  # based on some criteria
  counter = 0
  for line in data.split("\n")
    if line == ""
      continue
    counter += 1
  return counter

module.exports.countByColumnIndex = (data, index, properValue) ->
  counter = 0
  for line in data.split("\n")
    if line == ""
      continue
    cols = line.split(DELIMETER)
    if parseInt(cols[index]) == properValue
      counter += 1
  return counter



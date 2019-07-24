utils = require('./utils')
notification = require('./notification')
module.exports = (robot) ->
  # the expected value of :room is going to vary by adapter, it might be a numeric id, name, token, or some other value
  robot.router.post '/notification-deprecated', (request, response) ->
    data   = if request.body.payload? then JSON.parse request.body.payload else request.body
    n = new notification.Notification(data.line)
    n.parse()

    if data.raw
      console.log(n.notificationChannel)
      robot.messageRoom n.notificationChannel, data.line


    response.send 'OK'
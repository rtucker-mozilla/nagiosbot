###*
 * class handing brain storage and retrieval of notification data by integer index
 * @param {@robot} hubot instance
 * @param {@start} 1st integer index to assign to notification
 * @param {@width} Amount of indexes before restarting
 ###
exports.NotificationIndex = class NotificationIndex
  constructor: (@robot, @start, @width) ->
    @start = parseInt(@start)
    @width = parseInt(@width)
    @dataStoreEmpty = false
    @currentIndex = @robot.brain.get("currentIndex")
    @brainStart = @robot.brain.get("start")
    if !@brainStart?
      @dataStoreEmpty = true
      @robot.brain.set("start", @start)

    if !@currentIndex?
      @currentIndex = @start
      @robot.brain.set("currentIndex", @start)

    @maxIndex = @start + @width - 1
    @nextIndex = @getNextIndex()

  get: (id) ->
    id = parseInt(id)
    return @robot.brain.get(id)

  set: (notificationObject) ->
    @robot.brain.set(@currentIndex, notificationObject)
    nextIndex = @getNextIndex()
    @robot.brain.set("currentIndex", nextIndex) 

  getNextIndex: ->
    if @dataStoreEmpty == true
      nextValue = @currentIndex
    else if nextValue == @brainStart + @width
      nextValue = @start
    else
      nextValue = @currentIndex + 1
    return nextValue

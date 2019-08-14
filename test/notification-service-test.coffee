Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect
helper = new Helper('../scripts/nagiosbot-dispatch.coffee')

notification = require '../scripts/notification.coffee'
fs = require 'fs'

describe 'SERVICE notification', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'extracts timestamp', ->
    line = "[1529319170] SERVICE NOTIFICATION: infrastructurealertslist;generic2.db.scl3.mozilla.com;Puppet freshness;WARNING;notify-by-email;Last run had 2 errors"
    n = new notification.Notification(line)
    n.parse(line)
    properTimestamp = '1529319170'
    expect(n.timestamp).to.equal(properTimestamp)

  it 'extracts notificationType', ->
    line = "[1529319170] SERVICE NOTIFICATION: infrastructurealertslist;generic2.db.scl3.mozilla.com;Puppet freshness;WARNING;notify-by-email;Last run had 2 errors"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'SERVICE'
    expect(n.notificationType).to.equal(properValue)

  it 'extracts notificationDestination', ->
    line = "[1529319170] SERVICE NOTIFICATION: infrastructurealertslist;generic2.db.scl3.mozilla.com;Puppet freshness;WARNING;notify-by-email;Last run had 2 errors"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'infrastructurealertslist'
    expect(n.notificationDestination).to.equal(properValue)

  it 'extracts hostName', ->
    line = "[1529319170] SERVICE NOTIFICATION: infrastructurealertslist;generic2.db.scl3.mozilla.com;Puppet freshness;WARNING;notify-by-email;Last run had 2 errors"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'generic2.db.scl3.mozilla.com'
    expect(n.hostName).to.equal(properValue)

  it 'extracts serviceName', ->
    line = "[1529319170] SERVICE NOTIFICATION: infrastructurealertslist;generic2.db.scl3.mozilla.com;Puppet freshness;WARNING;notify-by-email;Last run had 2 errors"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'Puppet freshness'
    expect(n.serviceName).to.equal(properValue)

  it 'extracts notificationLevel', ->
    line = "[1529319170] SERVICE NOTIFICATION: infrastructurealertslist;generic2.db.scl3.mozilla.com;Puppet freshness;WARNING;notify-by-email;Last run had 2 errors"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'notify-by-email'
    # expect(n.notificationDestionation).to.equal(properValue)

  it 'extracts message', ->
    line = "[1565704013] SERVICE NOTIFICATION: irchilight;bacula1.private.mdc1.mozilla.com;Test for a service to break;CRITICAL;notify-by-email;FILE_AGE CRITICAL: /tmp/file_age_test is 349 seconds old and 0 bytes"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'FILE_AGE CRITICAL: /tmp/file_age_test is 349 seconds old and 0 bytes'
    expect(n.message).to.equal(properValue)

  it 'extracts status', ->
    line = "[1565704013] SERVICE NOTIFICATION: irchilight;bacula1.private.mdc1.mozilla.com;Test for a service to break;CRITICAL;notify-by-email;FILE_AGE CRITICAL: /tmp/file_age_test is 349 seconds old and 0 bytes"
    n = new notification.Notification(line)
    n.parse(line)
    properValue = 'CRITICAL'
    expect(n.notificationLevel).to.equal(properValue)

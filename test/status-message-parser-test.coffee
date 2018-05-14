Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/nagiosbot-dispatch.coffee')
parser = require '../scripts/status-message-parser.coffee'

describe 'status-message-parser.parse', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'sets message', ->
    message = "status"
    resp = parser.parse(message)
    expect(resp.message).to.equal(message)

  it 'status only returns proper emitCode', ->
    message = "status"
    resp = parser.parse(message)
    expect(resp.emitCode).to.equal("status:global")

  it 'hostname only service status sets proper hostOnly', ->
    message = "status foo.bar.domain.com"
    resp = parser.parse(message)
    expect(resp.hostOnly).to.equal(true)

  it 'hostname only service status sets proper hostOnly with dashes', ->
    console.log('sadfsdfasdfsdf')
    message = "status node.df501-1.vlan.location.domain.net"
    resp = parser.parse(message)
    expect(resp.hostOnly).to.equal(true)

  it 'hostname only service status sets proper hostOnly when host starts with http://', ->
    message = "status http://foo.bar.domain.com"
    resp = parser.parse(message)
    expect(resp.hostName).to.equal("foo.bar.domain.com")

  it 'hostname only service status sets proper hostOnly when host starts with http://', ->
    message = "status *http://foo.bar.domain.com"
    resp = parser.parse(message)
    expect(resp.hostName).to.equal("*foo.bar.domain.com")

  it 'hostname only service status sets proper hostName', ->
    message = "status foo.bar.domain.com"
    resp = parser.parse(message)
    expect(resp.hostName).to.equal("foo.bar.domain.com")

  it 'hostname only service status sets proper emitCode', ->
    message = "status foo.bar.domain.com"
    resp = parser.parse(message)
    expect(resp.emitCode).to.equal("status:host")

  it 'hostname and service name no spaces sets hostOnly to false', ->
    message = "status foo.bar.domain.com:Uptime"
    resp = parser.parse(message)
    expect(resp.hostOnly).to.equal(false)

  it 'hostname and service name no spaces sets hasService', ->
    message = "status foo.bar.domain.com:Uptime"
    resp = parser.parse(message)
    expect(resp.hasService).to.equal(true)

  it 'hostname and service name no spaces sets hostName correctly', ->
    message = "status foo.bar.domain.com:Uptime"
    resp = parser.parse(message)
    expect(resp.hostName).to.equal("foo.bar.domain.com")

  it 'hostname and service name no spaces sets serviceName correctly', ->
    message = "status foo.bar.domain.com:Uptime"
    resp = parser.parse(message)
    expect(resp.serviceName).to.equal("Uptime")

  it 'hostname and service name with spaces sets hostName correctly', ->
    message = "status foo.bar.domain.com:Check Name"
    resp = parser.parse(message)
    expect(resp.hostName).to.equal("foo.bar.domain.com")

  it 'hostname and service name wth spaces sets serviceName correctly', ->
    message = "status foo.bar.domain.com:Check Name"
    resp = parser.parse(message)
    expect(resp.serviceName).to.equal("Check Name")

  it 'hostname and wildcard service name sets serviceWildcard correctly', ->
    message = "status foo.bar.domain.com:*"
    resp = parser.parse(message)
    expect(resp.serviceWildcard).to.equal(true)

  it 'hostname and wildcard service name sets serivceName correctly', ->
    message = "status foo.bar.domain.com:*"
    resp = parser.parse(message)
    expect(resp.serviceName).to.equal("*")

  it 'hostname and service name no spaces sets emitCode', ->
    message = "status foo.bar.domain.com:service"
    resp = parser.parse(message)
    expect(resp.emitCode).to.equal("status:service")

  it 'hostname and service name with spaces sets emitCode', ->
    message = "status foo.bar.domain.com:service name"
    resp = parser.parse(message)
    expect(resp.emitCode).to.equal("status:service")

  it 'hostname and wildcard service name sets emitCode', ->
    message = "status foo.bar.domain.com:*"
    resp = parser.parse(message)
    expect(resp.emitCode).to.equal("status:service")

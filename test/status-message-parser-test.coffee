Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/nagiosbot-dispatch.coffee')
parser = require '../scripts/status-message-parser.coffee'
fs = require 'fs'

describe 'status-message-parser.parse', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'sets response', ->
    response = "status"
    smp = new parser.StatusMessageParser(response)
    smp.parse(response)
    expect(smp.response).to.equal(response)

  it 'status only returns proper emitCode', ->
    message = "status"
    resp = parser.parse(message)
    expect(resp.emitCode).to.equal("status:global")

  it 'hostname only service status sets proper hostOnly', ->
    message = "status foo.bar.domain.com"
    resp = parser.parse(message)
    expect(resp.hostOnly).to.equal(true)

  it 'hostname only service status sets proper hostOnly with dashes', ->
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

  it 'sets hostNameWildcard with an asterisk only for hostname', ->
    message = "status *:Ping"
    resp = parser.parse(message)
    expect(resp.hostNameWildcard).to.equal(true)

  it 'sets hostnamewildcard with an asterisk', ->
    message = "status *.domain.com:ping"
    resp = parser.parse(message)
    expect(resp.hostNameWildcard).to.equal(true)

  it 'sets serviceWildcard with an asterisk', ->
    message = "status *.domain.com:ping"
    resp = parser.parse(message)
    expect(resp.serviceWildcard).to.equal(false)

  it 'sets hostNameSearch with an asterisk', ->
    message = "status *.domain.com:ping"
    resp = parser.parse(message)
    expect(resp.hostNameSearch).to.equal('.domain.com$')

  it 'sets serviceNameSearch without asterisk', ->
    message = "status *.domain.com:Ping"
    resp = parser.parse(message)
    expect(resp.serviceNameSearch).to.equal('^Ping$')

  it 'sets serviceName ending anchor with leading asterisk', ->
    message = "status foo.domain.com:*Ping"
    resp = parser.parse(message)
    expect(resp.serviceNameSearch).to.equal('Ping$')

  it 'sets serviceName ending anchor with trailing asterisk', ->
    message = "status foo.domain.com:Ping*"
    resp = parser.parse(message)
    expect(resp.serviceNameSearch).to.equal('^Ping')

  it 'sets serviceName starting and ending anchor without leading and trailing asterisk', ->
    message = "status foo.domain.com:Ping"
    resp = parser.parse(message)
    expect(resp.serviceNameSearch).to.equal('^Ping$')

  it 'removes serviceName starting and ending anchor with leading and trailing asterisk', ->
    message = "status foo.domain.com:*Ping*"
    resp = parser.parse(message)
    expect(resp.serviceNameSearch).to.equal('Ping')

describe 'status-message-parser.format_status_response', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'splitResponse creates proper number of lines', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    properNumLines = 12
    splitResponse = parser.splitResponse livestatusResponse
    expect(splitResponse.length).to.equal(properNumLines)

  it 'extracts statusInt from line', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    smlp = new parser.StatusMessageLineParser(lines[0])
    smlp.parse()
    expect(0).to.equal(0)
    
  it 'extracts statusDescription from line 0', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    smlp = new parser.StatusMessageLineParser(lines[0])
    smlp.parse()
    properDescription = 'OK'
    expect(smlp.statusText).to.equal(properDescription)

  it 'extracts statusDescription from line 1', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    properDescription = 'CRITICAL'
    smlp = new parser.StatusMessageLineParser(lines[7])
    smlp.parse()
    expect(smlp.statusText).to.equal(properDescription)

  it 'extracts statusDescription from line 2', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    properDescription = 'WARNING'
    smlp = new parser.StatusMessageLineParser(lines[11])
    smlp.parse()
    expect(smlp.statusText).to.equal(properDescription)

  it 'extracts statusDescription from line 3', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    properDescription = 'UNKNOWN'
    smlp = new parser.StatusMessageLineParser(lines[10])
    smlp.parse()
    expect(smlp.statusText).to.equal(properDescription)

  it 'extracts hostname from line 1', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    hostname = parser.hostNameByLine lines[0]
    properHostname = 'access01.df501-1.vlan.loc2.domain.net'
    expect(hostname).to.equal(properHostname)

  it 'segementByDelimeter extracts properly', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = 'foo.bar.baz;0;1'
    expect(parser.segmentByDelimeter(lines, ';',0)).to.equal('foo.bar.baz')

  it 'extracts hostname from line 1', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    hostname = parser.hostNameByLine lines[0]
    properHostname = 'access01.df501-1.vlan.loc2.domain.net'
    expect(hostname).to.equal(properHostname)

  it 'extracts serviceName from line 1', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    serviceName = parser.serviceNameByLine lines[0]
    properServiceName = 'PING OK - Packet loss = 0%, RTA = 68.23 ms'
    expect(serviceName).to.equal(properServiceName)

  it 'class StatusMessageParser extracts serviceName from line', ->
    livestatusResponse = fs.readFileSync "test/fixtures/hostresponse", 'utf8'
    lines = parser.splitResponse livestatusResponse
    smlp = new parser.StatusMessageLineParser(lines[0])
    smlp.parse()
    properServiceName = 'PING OK - Packet loss = 0%, RTA = 68.23 ms'
    expect(smlp.serviceDescription).to.equal(properServiceName)

  it 'shouldGetFromBrain returns for integer only match to pull from brain', ->
    message = "@nagiosbot status 12345"
    response = parser.shouldGetFromBrain(message)
    properResponse = true
    expect(response).to.equal(properResponse)

  it 'shouldGetFromBrain returns false for noninteger only match to pull from brain', ->
    message = "@nagiosbot status foo.bar.domain.com:*"
    response = parser.shouldGetFromBrain(message)
    properResponse = false
    expect(response).to.equal(properResponse)

  it 'notificationIdFromMessage returns proper integer from message', ->
    message = "@nagiosbot status 12345"
    response = parser.notificationIdFromMessage(message)
    properResponse = 12345
    expect(response).to.equal(properResponse)

  it 'notificationIdFromMessage returns null when lacking integer from message', ->
    message = "@nagiosbot status asdf"
    response = parser.notificationIdFromMessage(message)
    properResponse = null
    expect(response).to.equal(properResponse)

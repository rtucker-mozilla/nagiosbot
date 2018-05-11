Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/nagiosbot-dispatch.coffee')
ls = require '../scripts/livestatus.js'
fs = require('fs')

describe 'livestatus.buildWildcardQuery', ->
  beforeEach ->
    @robot = {}
    @robot.name = "nagiosbot"
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'wildcard on both sides', ->
    iStr = "*foo.domain.com*"
    expect(ls.buildWildcardQuery(iStr)).to.equal("foo.domain.com")

  it 'no wildcard on front', ->
    iStr = "foo.domain.com*"
    expect(ls.buildWildcardQuery(iStr)).to.equal("^foo.domain.com")

  it 'no wildcard on end', ->
    iStr = "*foo.domain.com"
    expect(ls.buildWildcardQuery(iStr)).to.equal("foo.domain.com$")

  it 'no wildcard on either', ->
    iStr = "foo.domain.com"
    expect(ls.buildWildcardQuery(iStr)).to.equal("^foo.domain.com$")


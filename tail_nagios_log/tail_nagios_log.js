#!/usr/bin/node

/* Example notification lines to send to http listener


[1563240990] HOST NOTIFICATION: notificationgroup;host.domain.com;DOWN;host-notify-by-email;PING CRITICAL - Packet loss = 100%
[1563248404] SERVICE NOTIFICATION: notificationgroup;host.domain.com;Service Name;OK;notify-by-email;Service Message
*/

var Tail = require('always-tail');
var fs = require('fs');
var utils = require('./utils')
var filename = utils.logFilePath()

if (!fs.existsSync(filename)) fs.writeFileSync(filename, "");

var tail = new Tail(filename, '\n');

tail.on('line', function(data) {
  console.log("got line:", data);
});


tail.on('error', function(data) {
  console.log("error:", data);
});

tail.watch();
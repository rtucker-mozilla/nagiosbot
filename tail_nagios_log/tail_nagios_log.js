#!/usr/bin/node

/* Example notification lines to send to http listener


[1563240990] HOST NOTIFICATION: notificationgroup;host.domain.com;DOWN;host-notify-by-email;PING CRITICAL - Packet loss = 100%
[1563248404] SERVICE NOTIFICATION: notificationgroup;host.domain.com;Service Name;OK;notify-by-email;Service Message
*/

var Tail = require('always-tail');
var fs = require('fs');
var utils = require('./utils');
var filename = utils.logFilePath();
const axios = require('axios');

if (!fs.existsSync(filename)) fs.writeFileSync(filename, "");

var tail = new Tail(filename, '\n');
var url = utils.hubotURL();

tail.on('line', function(line) {
    var shouldPostResponse = utils.shouldPostLine(line);
    if(shouldPostResponse.value){
        axios.post(url + '/' + shouldPostResponse.endpoint, {line: line}).catch((error) => {
            console.log(error.code)
        })
    }
});


tail.on('error', function(data) {
  console.log("error:", data);
});

tail.watch();
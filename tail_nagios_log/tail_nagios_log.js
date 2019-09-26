#!/usr/bin/node

/* Example notification lines to send to http listener


[1563240990] HOST NOTIFICATION: notificationgroup;host.domain.com;DOWN;host-notify-by-email;PING CRITICAL - Packet loss = 100%
[1563248404] SERVICE NOTIFICATION: notificationgroup;host.domain.com;Service Name;OK;notify-by-email;Service Message
*/

var Tail = require('always-tail2');
var fs = require('fs');
var utils = require('./utils');
var util = require('util');
var filename = utils.logFilePath();
const axios = require('axios');
var hubotLogLevel = process.env.HUBOT_LOG_LEVEL || false

var shouldDebugLog = false;
if (hubotLogLevel == 'debug'){
    shouldDebugLog = true;
}

var log_file = fs.createWriteStream(__dirname + '/debug.log', {flags : 'w'});
var log_stdout = process.stdout;

console.log = function(d) { //
  log_file.write(util.format(d) + '\n');
  log_stdout.write(util.format(d) + '\n');
};

if (!fs.existsSync(filename)) fs.writeFileSync(filename, "");

var tail = new Tail(filename, '\n');
var url = utils.hubotURL();
if(shouldDebugLog){
    console.log("starting")
}
tail.on('line', function(line) {
    if(shouldDebugLog){
        console.log("got line: " + line)
    }
    var shouldPostResponse = utils.shouldPostLine(line);
    if(shouldPostResponse.value == true){
        if(shouldDebugLog){
            console.log("posting line: " + line)
        }
        axios.post(url + '/' + shouldPostResponse.endpoint, {line: line})
        .then((data) => {
            if(shouldDebugLog){
                console.log("got data response: " + data)
            }
        })
        .catch((error) => {
            if(shouldDebugLog){
                console.log(error.code)
            }
        })
    }
});


tail.on('error', function(data) {
  console.log("error:", data);
});

tail.watch();
function logFilePath(){
    return process.env.NAGIOS_LOGFILE || '/var/log/nagios/nagios.log';
} 

function hubotURL(){
    return process.env.HUBOT_URL || 'http://127.0.0.1:8080';
} 

var postLineMapping = {
    notification: [
        /^\[\d+\] HOST NOTIFICATION:/,
        /^\[\d+\] SERVICE NOTIFICATION:/
    ],
    ack: [
        /^\[\d+\] EXTERNAL COMMAND: ACKNOWLEDGE_HOST_PROBLEM;/,
        /^\[\d+\] EXTERNAL COMMAND: ACKNOWLEDGE_SVC_PROBLEM;/,
    ]
}

function shouldPostLine(line){
    retVal = {
        value: false,
        endpoint: ""
    }
    for ( var postLines of Object.keys(postLineMapping)){
        postLineMapping[postLines].forEach(function(re){
            if (re.test(line)){
                retVal.value = true;
                retVal.endpoint = postLines;
                return retVal;
            }
        });
    }
    return retVal;
}

module.exports.logFilePath = logFilePath;
module.exports.shouldPostLine = shouldPostLine;
module.exports.hubotURL = hubotURL;
function logFilePath(){
    return process.env.NAGIOS_LOGFILE || '/var/log/nagios/nagios.log';
} 

function hubotURL(){
    return process.env.HUBOT_URL || 'http://127.0.0.1:8080';
} 

postLines = new Array(
    /^\[\d+\] HOST NOTIFICATION:/,
    /^\[\d+\] SERVICE NOTIFICATION:/,

)


function shouldPostLine(line){
    retVal = false;
    postLines.forEach(function(re){
        if (re.test(line)){
            retVal = true
            return retVal;
        }
    });

    return retVal;

}

module.exports.logFilePath = logFilePath;
module.exports.shouldPostLine = shouldPostLine;
module.exports.hubotURL = hubotURL;
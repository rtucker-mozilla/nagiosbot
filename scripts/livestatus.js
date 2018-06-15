var net = require('net')
module.exports.executeQuery = function(socketPath, query, cb){
    var client = net.createConnection(socketPath);
    var data;
    client.on("connect",  function() {
        client.write(query, function(data){
        });
    });
    //client.destroy(); // kill client after server's response
    //client.on("data",  function(data) {
    client.on("data",  function(idata) {
        //client.destroy(); // kill client after server's response
        data = idata.toString();
    });
    client.on("close",  function() {
        client.destroy(); // kill client after server's response
        cb(data);
    });
};

module.exports.buildWildcardQuery = function(iStr){
  if(iStr.startsWith("*") && iStr.endsWith("*")){
    return iStr.replace(/\*/g,'');
  }
  if(!iStr.startsWith("*") && !iStr.endsWith("*")){
    return "^" + iStr.replace(/\*/g,'') + "$";
  }
  if(!iStr.endsWith("*")){
    return iStr.replace(/\*/g,'') + "$";
  }
  if(!iStr.startsWith("*")){
    return "^" + iStr.replace(/\*/g,'');
  }
  if(!iStr.endsWith("*")){
    return iStr.replace(/\*/g,'') + "$";
  }

};


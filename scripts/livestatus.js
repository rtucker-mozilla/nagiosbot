var net = require('net')
module.exports.executeQuery = function(socketPath, query, cb){
    var client = net.createConnection(socketPath);
    client.on("connect",  function() {
        client.write(query, function(data){
        });
    });
    //client.destroy(); // kill client after server's response
    client.on("data",  function(data) {
        client.destroy(); // kill client after server's response
        cb(data.toString());
    });
    client.on("close",  function(data) {
        client.destroy(); // kill client after server's response
        cb();
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


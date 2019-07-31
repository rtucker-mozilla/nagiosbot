var net = require('net')
module.exports.executeQuery = function(socketPath, query, cb){
    return new Promise (function(resolve, reject){
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
          data = idata.toString().trim();
          resolve(data);
      });
      client.on("close",  function() {
          client.destroy(); // kill client after server's response
          reject(data);
      });
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

module.exports.getHost = function(socketPath, hostname){
    return new Promise (function(resolve, reject){
      hostQueryArray = [
        "GET hosts",
        "Columns: host_name state plugin_output last_check host_acknowledged address",
        "Filter: host_name ~ " + module.exports.buildWildcardQuery(hostname)
      ]
      hostQuery = hostQueryArray.join("\n") + "\n\n"
      livestatus.executeQuery(socketPath, hostQuery).then((data) => {
        resolve(data)
      }).error( (error) => {
        reject(error)
      });
    });

}


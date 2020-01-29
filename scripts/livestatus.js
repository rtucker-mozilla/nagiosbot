var net = require('net')
socketPath = process.env.HUBOT_LIVESTATUS_SOCKET_PATH
module.exports.executeQuery = function(query){
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
      });
      client.on("close",  function() {
          client.destroy(); // kill client after server's response
          resolve(data);
      });
      client.on("error",  function(err) {
          console.log(err)
          reject(new Error("Query Failed"));
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

module.exports.getHost = function(hostname){
    return new Promise (function(resolve, reject){
      hostQueryArray = [
        "GET hosts",
        "Columns: host_name state plugin_output last_check host_acknowledged address downtimes contact_groups contacts",
        "Filter: host_name ~ " + module.exports.buildWildcardQuery(hostname)
      ]
      hostQuery = hostQueryArray.join("\n") + "\n\n"
      module.exports.executeQuery(hostQuery).then((data) => {
        if(data){
          console.log(data)
          resolve(data)
        } else {
          reject("Host not found: " + hostname)
        }
      }).catch((error) => {
        reject(new Error("Host Not Found"))
      });
    });

}


module.exports.downtimesByHost = function(hostname){
    hostname = hostname.replace(/^http\:\/\//, "")
    return new Promise (function(resolve, reject){
      queryArray = [
        "GET downtimes",
        "Columns: id",
        "Filter: host_alias ~ " + hostname
      ]
      hostQuery = queryArray.join("\n") + "\n\n"
      module.exports.executeQuery(hostQuery).then((data) => {
        if(data){
          resolve(data)
        } else {
          reject("Downtimes not found for host: " + hostname)
        }
      }).catch((error) => {
        reject(new Error("Host Not Found"))
      });
    });

}


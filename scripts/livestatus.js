var net = require('net')
module.exports.executeQuery = function(socketPath, query, cb){
    var client = net.createConnection(socketPath);
    client.on("connect",  function() {
        client.write("GET hosts\n\n", function(data){
        });
    });
    //client.destroy(); // kill client after server's response
    client.on("data",  function(data) {
        client.destroy(); // kill client after server's response
        cb(data.toString());
    });
};

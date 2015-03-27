// Generated by CoffeeScript 1.9.1
(function() {
  module.exports = function(io, auth, options, callback) {
    var timeout;
    if (typeof options === 'function') {
      callback = options;
      options = {};
    }
    options.timeout || (options.timeout = 1000);
    timeout = function(time, fn) {
      return setTimeout(fn, time);
    };
    return io.on('connection', function(socket) {
      var disconnect;
      disconnect = function(message) {
        if (message == null) {
          message = 'unauthorized';
        }
        return socket.disconnect(message);
      };
      timeout(options.timeout, function() {
        if (!socket.authenticated) {
          return disconnect('unauthorized');
        }
      });
      socket.authenticated = false;
      return socket.on('authenticate', function(data) {
        return auth(data, function(error) {
          if (error != null) {
            return disconnect(error);
          } else {
            socket.authenticated = true;
            socket.emit('authenticated');
            return callback(socket);
          }
        });
      });
    });
  };

}).call(this);
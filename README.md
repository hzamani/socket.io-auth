# socket.io-auth

It provides a hook to authenticate [socket.io](https://github.com/Automattic/socket.io)
without using query-strings to send credentials, which is not a good security practice.

It works by preventing access to socket object before authentication, which is
done by given auth function and submitted credentials on `authenticate` event.

## Installation

```bash
npm install socket.io-auth
```

## Usage

Just pass socket.io server and `auth` function to `socket.io-auth` and add other
events on callback:
```javascript
var io = require('socket.io')(4000)

// setup and authentication method
auth = function(data, done) {
  // check for valid credential data
  if (data.token == 'test') {
    done();
  } else {
    done(new Error('bad credentials')) // or any error message
  }
};

require('socket.io-auth')(io, auth, function(socket){
  // use socket as before to implement other signals
  socket.on('ping', function(data){
    socket.emit('pong', data);
  });
});
```

you can set authentication window with timeout option (default is 1s (1000ms)):

```javascript
require('socket.io-auth')(io, auth, {timeout: 2000}, function(socket){
  // rest of code ...
});
```

clients just need to authenticate after connection:
```javascript
var socket = require('socket.io-client')('http://localhost:4000');

socket.on('connect', function(){
  socket.emit('authenticate', {token: 'some token'});
  socket.on('authenticated', function(){
    // now it is an authenticated socket and works as before
  });
});
```

## Contribute

You are always welcome to open an issue or provide a pull-request!

Also checkout the tests:

```
$ npm test

  socket.io-auth
    before authentication
      ✓ marks socket as unauthenticated
      ✓ dose not sent messages to sockets
      ✓ disconnects unauthenticated sockets after timeout window
    on authentication
      with valid credentials
        ✓ authenticates and emits authenticated signal
      with invalid credentials
        ✓ disconnects the socket
        ✓ emits unauthenticated with error message
    after authentication
      ✓ handles all signals normally
```


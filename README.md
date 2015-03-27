# socket.io-auth

It provides a hook to authenticate [socket.io](https://github.com/Automattic/socket.io)
without using querystrings to send credentials, which is not a good security practice.

It works by deling access to socket object for geting `authenticate` event, and
use given function to authenticate submited cridentials.

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
  // check for valid cridental data
  if (data.token == 'test') {
    done();
  } else {
    done(new Error('bad cridentials')) // or any error message
  }
};

require('socket.io-auth')(io, auth, function(socket){
  // use socket as before to impeliment other signals
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
      with valid cridentials
        ✓ authenticates and emits authenticated signal
      with invalid cridentials
        ✓ disconnects the socket
        ✓ emits unauthenticated with error message
    after authentication
      ✓ handel all signals normaly
```


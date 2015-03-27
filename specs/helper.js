require('coffee-script/register');
io = require('socket.io-client');
expect = require('chai').expect;

server = require('./test-server');

timeout = function(time, fn) { setTimeout(fn, time); };

io = require('socket.io')()
authenticate = require '../'

auth = (data, done) ->
  if data.token == 'sometoken!'
    done()
  else
    done('unauthorized')

authenticate io, auth, (socket) ->
  socket.on 'ping', (data) ->
    socket.emit 'pong', data

module.exports = io

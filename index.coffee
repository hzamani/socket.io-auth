module.exports = (io, auth, options, callback) ->
  if typeof(options) == 'function'
    callback = options
    options = {}

  options.timeout ||= 1000

  timeout = (time, fn) -> setTimeout(fn, time)

  io.on 'connection', (socket) ->
    disconnect = (error='unauthorized') ->
      if error instanceof Error
        error = error.message
      socket.emit 'unauthenticated', error
      socket.disconnect()

    timeout options.timeout, ->
      disconnect('authentication timeout') unless socket.authenticated

    socket.authenticated = false
    socket.on 'authenticate', (data) ->
      auth data, (error) ->
        if error?
          disconnect(error)
        else
          socket.authenticated = true
          socket.emit 'authenticated'
          callback(socket)


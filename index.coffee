module.exports = (io, auth, options, callback) ->
  if typeof(options) == 'function'
    callback = options
    options = {}

  options.timeout ||= 1000

  timeout = (time, fn) -> setTimeout(fn, time)

  io.on 'connection', (socket) ->
    disconnect = (message='unauthorized') ->
      # FIXME: socket.emit 'error', message
      socket.disconnect(message)

    timeout options.timeout, ->
      disconnect('unauthorized') unless socket.authenticated

    socket.authenticated = false
    socket.on 'authenticate', (data) ->
      auth data, (error) ->
        if error?
          disconnect(error)
        else
          socket.authenticated = true
          socket.emit 'authenticated'
          callback(socket)


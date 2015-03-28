
port = 4000
url = "http://localhost:#{port}"

server.listen(port)

validCredentials = {token: "sometoken!"}
invalidCredentials = {token: "bad token"}

describe 'socket.io-auth', ->
  socket = null

  beforeEach ->
    socket = io(url, {'force new connection': true})

  afterEach ->
    socket.disconnect()

  context 'before authentication', ->
    it 'marks socket as unauthenticated', ->
      expect(socket.authenticated).to.not.be.ok

    it 'dose not sent messages to sockets', (done) ->
      socket.on 'pong', ->
        done(new Error 'got message while unauthorized')
      timeout 500, done

    it 'disconnects unauthenticated sockets after timeout window', (done) ->
      socket.on 'disconnect', ->
        done()

  context 'on authentication', ->
    context 'with valid credentials', ->
      it 'authenticates and emits authenticated signal', (done) ->
        socket.on 'authenticated', ->
          done()
        socket.emit 'authenticate', validCredentials

    context 'with invalid credentials', ->
      it 'disconnects the socket', (done) ->
        socket.on 'disconnect', ->
          done()
        socket.emit 'authenticate', invalidCredentials

      it 'emits unauthenticated signal with error message', (done) ->
        socket.on 'unauthenticated', (data) ->
          expect(data).to.not.be.empty
          done()
        socket.emit 'authenticate', invalidCredentials

  context 'after authentication', ->
    it 'handles all signals normally', (done) ->
      socket.emit 'authenticate', {token: 'sometoken!'}
      socket.on 'pong', (data) ->
        if data == 'test message'
          done()
      socket.emit 'ping', 'test message'


module.exports.listen = (app) ->
  socket = require('socket.io').listen(app)
  clients = {}

  socket.on 'connection', (client) ->
    for id, data of clients
      client.send JSON.stringify(['mousemove', id, data])

    broadcast = (event, data) -> client.broadcast JSON.stringify([event, client.sessionId, data])

    client.on 'message', (json) ->
      [event, data] = JSON.parse(json)

      switch event
        when 'mousemove'
          clients[client.sessionId] = data
          broadcast event, data
        when 'mouseleave'
          delete clients[client.sessionId]
          broadcast event
        else
          console.log event, data

    client.on 'disconnect', ->
      delete clients[client.sessionId]
      broadcast 'disconnect'

module.exports.listen = (app) ->
  socket = require('socket.io').listen(app)

  socket.on 'connection', (client) ->
    broadcast = (event, data) ->
      client.broadcast JSON.stringify([event, client.sessionId, data])

    client.on 'message', (json) ->
      [event, data] = JSON.parse(json)

      switch event
        when 'mousemove', 'mouseleave'
          broadcast event, data
        else
          console.log event, data

    client.on 'disconnect', ->
      broadcast 'disconnect'

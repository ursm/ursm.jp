module.exports.listen = (app) ->
  socket = require('socket.io').listen(app)

  socket.on 'connection', (client) ->
    client.on 'message', (json) ->
      [event, data] = JSON.parse(json)

      switch event
        when 'mousemove'
          client.broadcast JSON.stringify([event, client.sessionId, data])
        else
          console.log event, data

    client.on 'disconnect', ->
      client.broadcast JSON.stringify(['disconnect', client.sessionId])

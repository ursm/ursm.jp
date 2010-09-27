class Firefly
  constructor: (@id) ->
    @elem = $("div#c#{@id}")

  isCaged: ->
    @elem.length > 0

  encage: (cage) ->
    @elem = $("<div class='firefly' id='c#{@id}' />").css(
      'background-image': "-webkit-gradient(radial, center center, 5, center center, 15, from(hsla(#{@id % 360}, 100%, 70%, 1)), to(hsla(0, 100%, 100%, 0)))"
    ).appendTo(cage)

  flyTo: (pos) ->
    @elem.css pos

  uncage: ->
    @elem.remove()

$(document).ready ->
  socket = new io.Socket(document.location.hostname, port: 8000)
  cage = $('<div/>').appendTo('body')

  socket.on 'message', (json) ->
    [event, client, data] = JSON.parse(json)
    firefly = new Firefly(client)

    switch event
      when 'mousemove'
        firefly.encage cage unless firefly.isCaged()
        firefly.flyTo data
      when 'mouseleave', 'disconnect'
        firefly.uncage()
      else
        console.log event, client, data

  socket.connect()

  send = (event, data) -> socket.send JSON.stringify([event, data])

  $('html').mousemove (e) ->
    send 'mousemove', top: e.pageY - 15, left: e.pageX - 15
  .mouseleave ->
    send 'mouseleave'

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

socket = new io.Socket(document.location.hostname, port: 8000)
socket.connect()

$(document).ready ->
  cage = $('<div/>').appendTo('body')

  socket.on 'message', (json) ->
    [event, client, data] = JSON.parse(json)
    firefly = new Firefly(client)

    switch event
      when 'mousemove'
        firefly.encage cage unless firefly.isCaged()
        firefly.flyTo data
      when 'disconnect'
        firefly.uncage()
      else
        console.log event, client, data

  $('html').mousemove (e) -> socket.send JSON.stringify(['mousemove', top: e.pageY, left: e.pageX])

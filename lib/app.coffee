path = require('path')
express = require('express')

app = module.exports = express.createServer()

app.configure ->
  root = (paths...) -> path.join(__dirname, '..', paths...)

  app.use express.compiler(src: root('src'), dest: root('public'), enable: ['sass', 'coffeescript'])
  app.use express.staticProvider(root('public'))
  app.use express.logger()

  app.set 'view engine', 'haml'
  app.set 'view options', layout: false

app.configure 'development', ->
  app.use express.errorHandler(dumpExceptions: true, showStack: true)

app.configure 'production', ->
  app.use express.errorHandler()


app.get '/', (req, res) ->
  res.render 'index'


require('./socket').listen app

unless module.parent
  app.listen 3000
  console.log "Express server listening on port #{app.address().port}"

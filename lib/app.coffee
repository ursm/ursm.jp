express = require('express')

app = module.exports = express.createServer()

app.configure ->
  app.use express.compiler(src: "#{__dirname}/src", dest: "#{__dirname}/public", enable: ['sass', 'coffeescript'])
  app.use express.staticProvider("#{__dirname}/public")

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

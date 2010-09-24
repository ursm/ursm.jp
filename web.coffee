path = require('path')
express = require('express')

root = (paths...) -> path.join(__dirname, paths...)

app = module.exports = express.createServer()

app.configure ->
  app.use express.compiler(src: root('src'), dest: root('public'), enable: ['sass', 'coffeescript'])
  app.set 'view engine', 'haml'
  app.set 'view options', layout: false

app.configure 'development', ->
  app.use express.staticProvider(root('public'))
  app.use express.errorHandler(dumpExceptions: true, showStack: true)
  app.use express.logger()

app.configure 'production', ->
  app.use express.errorHandler()
  app.use express.logger(buffer: true)

app.get '/', (req, res) ->
  res.render 'index'

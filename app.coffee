require.paths.unshift './vendor'

web = module.exports = require('./servers/web')
require('./servers/socket').listen web

web = require('./web')

require('./socket').listen web
web.listen process.argv.shift()

console.log "Express server listening on port #{web.address().port}"

###
|------------------------------------------------------------------------------
| Global App Startup
|------------------------------------------------------------------------------
###

# Loading the configuration
config = require('./config')

# Load Express / Server
express = require('express')
app = express()
server = require('http').createServer(app)

# Utilities
global._ = _ = require('lodash')

# Load Logger
logger = require(__dirname + '/controllers/LoggerController')({
  testing: process.env.TESTING || false
})

# Register some stuff as a global.
_.extend(global, {
  app
  config
  server
  logger
})


logger.info('Starting the ' + config.app.name + ' version ' + config.app.version)

app.controllers = require('./controllers')

###
|------------------------------------------------------------------------------
| Global Configuration
|------------------------------------------------------------------------------
###

app.configure(() ->
  # App Settings
  app.set('title', config.app.name)

  app.use(express.logger({
    format: 'dev' # short, tiny | http://www.senchalabs.org/connect/logger.html
    stream: {
      write: (str) -> logger.info(str.replace(/(\r\n|\n|\r)/gm,""))
    }
  }))



  # Settings for the View
  app.set('views', config.view.paths)
  app.set('view engine', config.view.engine)

  # Engines to Render Template Files
  engines = require('consolidate')
  app.engine('jade', engines.jade)

  # Public Static Files
  app.use('/', express.static(
    config.paths.public
    {
      maxAge: 86400000  # 86400000 = oneDay
    }
  ))

  # Middleware
  app.use(express.compress())
  app.use(express.cookieParser())
  app.use(express.bodyParser({ keepExtensions: true, uploadDir: '/my/files' }))
  app.use(express.methodOverride())

  # Setting up variables to be usable in jade
  app.locals({
    env: process.env
    frontEndVersion: config.app.frontEndVersion
    safeValue: (value, value2='') ->
      if typeof value == 'undefined'
        if typeof value2 == 'undefined'
          return ''
        else
          return value2
      else
        return value
  })
  app.use((req, res, next) ->
    res.locals ?= {}
    res.locals.req = req
    res.locals.res = res
    res.locals.path = req.path
    next()
  )

  # Router Setup
  app.use(app.router)
)

###
|------------------------------------------------------------------------------
| Environment Specific Settings
|------------------------------------------------------------------------------
###
app.configure('development', ->
  app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }))
)

app.configure('production', ->
  app.use(express.errorHandler)
)

###
|------------------------------------------------------------------------------
| Require the most important files
|------------------------------------------------------------------------------
###
require('./routes')

# Run the scraper once and fill the cache.
app.controllers.ScraperController.start()

###
|------------------------------------------------------------------------------
| Startup the Server
|------------------------------------------------------------------------------
###
server.listen(config.server.port, config.server.address, ->
  logger.info 'Express server listening', {
    address: server.address().address
    port: server.address().port
    env: app.settings.env
  }
)

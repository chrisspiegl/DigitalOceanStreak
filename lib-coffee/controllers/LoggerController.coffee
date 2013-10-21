class LoggerController

  @getInstance: ->
    @_instance ?= new @( arguments... )

  winston = null

  constructor: (@config) ->
    winston = require('winston')
    # winston.exitOnError = false
    # winston.remove(winston.transports.Console)
    # winston.add(winston.transports.Console, {
    #   level: 'debug'
    #   # handleExceptions: true
    #   silent: @config.testing || false
    #   colorize: true
    #   timestamp: true
    #   json: false
    # })
    # winston.add(winston.transports.File, {
    #     level: 'info'
    #     # handleExceptions: true
    #     silent: false
    #     colorize: false
    #     timestmp: true
    #     filename: __dirname + '/../../tmp/console-output.log'
    #     # maxsize:
    #     # maxFiles:
    #     # stream:
    #     json: false
    # })

  debug: (msg, meta=null)->
    meta ?= {}
    _.extend(meta, @getLineAndFile())
    winston.debug(msg, meta)
  info: (msg, meta=null) ->
    meta ?= {}
    _.extend(meta, @getLineAndFile())
    winston.info(msg, meta)
  warn: (msg, meta=null) ->
    meta ?= {}
    _.extend(meta, @getLineAndFile())
    winston.warn(msg, meta)
  error: (msg, meta=null) ->
    meta ?= {}
    _.extend(meta, @getLineAndFile())
    winston.error(msg, meta)
  err: (msg, meta=null) ->
    meta ?= {}
    _.extend(meta, @getLineAndFile())
    winston.error(msg, meta)

  getLineAndFile: () ->
    e = new Error()
    line = e.stack.split('\n')[3].split(':')[1]
    filename = e.stack.split('\n')[3].split(/(at )(.*)(\ \()/)[2]
    return { line: line, filename: filename }



module.exports = -> LoggerController.getInstance( arguments... )

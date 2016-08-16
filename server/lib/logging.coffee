@logger = Winston

logger.add Winston.transports.File,
  filename: 'all-logs.log'
  handleExceptions: true
  humanReadableUnhandledException: true

logger.add  Winston_Papertrail,
  levels:
    debug: 0
    info: 1
    warn: 2
    error: 3
    auth: 4
  colors:
    debug: 'blue'
    info: 'green'
    warn: 'red'
    error: 'red'
    auth: 'red'
  host: 'logs4.papertrailapp.com'
  port: 34781
  logFormat: (level, message) ->
    "[#{level}] #{message}"
  inlineMeta: true

logger.exitOnError = false
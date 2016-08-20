if Meteor.isServer
  logger.info('server started, log with winston', new Date())

Meteor.methods({
  'echo': (msg) ->
    console.log 'echo', msg
    msg
})
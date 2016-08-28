if Meteor.isServer
  logger.info('server started, log with winston', new Date())

Meteor.methods({
  'echo': (msg) ->
    console.log 'echo', msg
    msg
  'test': () ->
    test()
})

test = () ->
  1 + 1
  #API.addSubscription(5790000016020)
  #API.requestResendProducts(5790000016020)
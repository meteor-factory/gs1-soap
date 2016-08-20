
listeners = [];

@DRC =
  addListener : (callback) ->
    listeners.push callback
  clearListeners : () ->
    listeners = []
  removeListener : (callback) ->
    index = listeners.indexOf(callback)
    if index >= 0
      listeners.splice index, 1
  emit : (args) ->
    console.log 'emitter called'
    listeners.forEach (listener) -> listener(args)

service =
  DataRecipientOperationsCallbackService:
    wsHttpEndpoint:
      ReceiveCatalogueItemNotification: (args) ->
        logger.info 'ReceiveCatalogueItemNotification', {args}
        #determine correct output
        @DRC.emit(args)
        response =
          ReceiveCatalogueItemNotificationResult: @GS1.getResponse @GS1.responseCodes.ACCEPTED
        response
      ReceiveCatalogueItemHierarchicalWithdrawal: (args) ->
        logger.info 'ReceiveCatalogueItemHierarchicalWithdrawal', {args}
        #determine correct output
        response =
          ReceiveCatalogueItemHierarchicalWithdrawalResult: @GS1.getResponse @GS1.responseCodes.ACCEPTED
        response

Meteor.startup () ->
  wsdl = Assets.getText Meteor.settings.wsdlPath + 'DataRecipientOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapDRC", service, wsdl
  logger.info 'DataRecipientOperationsCallbackService listener started'


Meteor.methods(
  'addSubscriptionTest': () ->
    @DR.addSubscription 123, 456
  'addSubscription': (gln, gtin) ->
    @DR.addSubscription gln, gtin
)
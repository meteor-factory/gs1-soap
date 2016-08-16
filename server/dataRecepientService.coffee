
listeners = [];

@DR =
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
        @DR.emit(args)
        args
      ReceiveCatalogueItemHierarchicalWithdrawal: (args) ->
        logger.info 'ReceiveCatalogueItemHierarchicalWithdrawal', {args}
        #determine correct output
        args

Meteor.startup () ->
  wsdl = Assets.getText Meteor.settings.wsdlPath + 'DataRecipientOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapDRC", service, wsdl
  logger.info 'DataRecipientOperationsCallbackService listener started'
  #Meteor.call 'addSubscription', 123, 456


client = null;
getClient = () ->
  if client is null
    client = Soap.createClient GS1.endpoints.dataRecipient + "?wsdl"
  client


Meteor.methods(
  'addSubscriptionTest': () ->
    Meteor.call 'addSubscription', 123, 456
  'addSubscription': (gln, gtin) ->
    try
      client = getClient()
      request =
        catalogueItemSubscriptionType:
          creationDateTime: new Date()
          dataRecipient: GS1.gln.fooducer
          dataSource: gln
          gtin: gtin
          targetMarket:
            targetMarketCountryCode: 208
        standardBusinessDocumentHeader: GS1.getHeader GS1.messageTypes.catalogItemSubscription

      result = client.AddSubscription request
      logger.log 'added subscription', {result}
      return result
    catch err
      logger.error 'add subscription failed', {gln, gtin, err}
      if err.error is 'soap-creation'
        console.log 'SOAP client creation failed', err
      else if err.error is 'soap-method'
        console.log 'SOAP method call failed', err
      else
        console.log 'SOAP unexpected error', err
)
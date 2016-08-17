
@DR =
  addSubscription: (gln, gtin) ->
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

client = null;
getClient = () ->
  if client is null
    client = Soap.createClient GS1.endpoints.dataRecipient + "?wsdl"
  client


@DR =
  addSubscription: (gln) ->
    try
      client = getClient()
      console.log "client created"
      request =
        catalogueItemSubscriptionType:
          creationDateTime:
            attributes:
              xmlns: ""
            $value: new Date().toISOString()
          documentStatusCode:
            attributes:
              xmlns: ""
            $value: "ORIGINAL"
          catalogueItemSubscriptionIdentification:
            attributes:
              xmlns: ""
            entityIdentification: "CatalogueItemSubscription-" + uuid.v4()
            contentOwner:
              gln: gln
          dataRecipient:
            attributes:
              xmlns: ""
            $value: GS1.gln.GS1
          dataSource:
            attributes:
              xmlns: ""
            $value: GS1.gln.fooducer
          targetMarket:
            attributes:
              xmlns: ""
            targetMarketCountryCode: "208"
        standardBusinessDocumentHeader: GS1.getHeader GS1.messageTypes.catalogueItemSubscription
      console.log "req", request
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
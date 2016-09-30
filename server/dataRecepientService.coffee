
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
              gln: GS1.gln.fooducer
          dataRecipient:
            attributes:
              xmlns: ""
            $value: GS1.gln.fooducer
          dataSource:
            attributes:
              xmlns: ""
            $value: gln
          targetMarket:
            attributes:
              xmlns: ""
            targetMarketCountryCode: "208"
        standardBusinessDocumentHeader: GS1.getHeader GS1.messageTypes.catalogueItemSubscription
      console.log "req", request
      result = client.AddSubscription request
      logger.info 'added subscription', {result}
      return result
    catch err
      logger.error 'add subscription failed', {gln, gtin, err}
      if err.error is 'soap-creation'
        console.log 'SOAP client creation failed', err
      else if err.error is 'soap-method'
        console.log 'SOAP method call failed', err
      else
        console.log 'SOAP unexpected error', err
  requestResendProducts: (gln) ->
    try
      client = getClient()
      console.log "client created"
      request =
        requestForCatalogueItemNotificationType:
          creationDateTime:
            attributes:
              xmlns: ""
            $value: new Date().toISOString()
          documentStatusCode:
            attributes:
              xmlns: ""
            $value: "ADDITIONAL_TRANSMISSION"
          catalogueItemSubscriptionIdentification:
            attributes:
              xmlns: ""
            entityIdentification: "RequestForCatalogueItemNotificationType-" + uuid.v4()
            contentOwner:
              gln: GS1.gln.fooducer
          dataRecipient:
            attributes:
              xmlns: ""
            $value: GS1.gln.fooducer
          dataSource:
            attributes:
              xmlns: ""
            $value: gln
          recipientDataPool:
            attributes:
              xmlns: ""
            $value: GS1.gln.GS1
          targetMarket:
            attributes:
              xmlns: ""
            targetMarketCountryCode: "208"
          isReload:
            attributes:
              xmlns: ""
            $value: true
        standardBusinessDocumentHeader: GS1.getHeader GS1.messageTypes.catalogueItemSubscription
      console.log "req", request
      result = client.AddRequestForCatalogueItemNotification request
      logger.info 'request resend products', {result}
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

@DS =
  updateProduct: (product) ->

    gtin = GS1.getPropSafe product, ['catalogueItemNotificationType', 'CatalogueItemNotificationType', 'catalogueItem', 'tradeItem', 'gtin']

    try
      client = getClient()
        
      #todo deal with add or update
      #todo deal with messageType

      request =
        catalogueItemNotification: product
        standardBusinessDocumentHeader: GS1.getHeader GS1.messageTypes.catalogueItemNotification

      result = client.ReceiveCatalogueItemNotification request
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
    client = Soap.createClient GS1.endpoints.dataSource + "?wsdl"
  client

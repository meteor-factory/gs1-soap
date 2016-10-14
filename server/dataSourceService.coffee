

@DS =
  updateProduct: (product) ->
    try
      client = getClient()

      setNs = (item) ->
        for key in Object.keys item
          value = item[key]
          if typeof(value) is "object"
            if value is null
              value =
                $value: null
            if key isnt "attributes"
              value.attributes = { xmlns: "" }
          else
            item[key] =
              attributes: {xmlns: ""}
              $value: value

      fixExtensionsNs = (extensions) ->
        for key of extensions
          value = extensions[key]
          console.log key, value
          xmlns = value.attributes["xsi:schemaLocation"].split(" ")[0]
          value.attributes.xmlns = xmlns
          setNs value

      traverseForExtensions = (obj) ->
        for key of obj
          value = obj[key]
          if key is "extension"
            fixExtensionsNs value
          if typeof(value) is "object" and value isnt null
            traverseForExtensions value


      product.catalogueItemNotificationType.CatalogueItemNotificationType.map setNs
      traverseForExtensions product

      request =
        catalogueItemNotification: product.catalogueItemNotificationType
        standardBusinessDocumentHeader: GS1.getHeader GS1.messageTypes.catalogueItemNotification

      result = client.ReceiveCatalogueItemNotification request
      logger.info 'updated product', {result}
      return result
    catch err
      console.log 'error', err
      logger.error 'sending product failed', {err}
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

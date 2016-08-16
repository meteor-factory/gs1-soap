
service =
  DataSourceOperationsCallbackService:
    wsHttpEndpoint:
      ReceiveCatalogueItemConfirmation: (args) ->
        logger.info 'ReceiveCatalogueItemConfirmation', {args}
        args

Meteor.startup () ->
  wsdl = Assets.getText Meteor.settings.wsdlPath + 'DataSourceOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapDSC", service, wsdl
  logger.info 'DataSourceOperationsCallbackService listener started'

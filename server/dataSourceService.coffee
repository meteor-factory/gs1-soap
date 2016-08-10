
service =
  DataSourceOperationsCallbackService:
    wsHttpEndpoint:
      ReceiveCatalogueItemConfirmation: (args) ->
        logger = Winston
        logger.info 'ReceiveCatalogueItemConfirmation', {args}
        args

Meteor.startup () ->
  wsdl = Assets.getText 'wsdl/DataSourceOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapSC", service, wsdl
  logger = Winston
  logger.info 'DataSourceOperationsCallbackService listener started'

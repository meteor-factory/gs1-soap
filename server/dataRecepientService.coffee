
service =
  DataRecipientOperationsCallbackService:
    wsHttpEndpoint:
      ReceiveCatalogueItemNotification: (args) ->
        logger = Winston
        logger.info 'ReceiveCatalogueItemNotification', {args}
        #determine correct output
        args
      ReceiveCatalogueItemHierarchicalWithdrawal: (args) ->
        logger = Winston
        logger.info 'ReceiveCatalogueItemHierarchicalWithdrawal', {args}
        #determine correct output
        args

Meteor.startup () ->
  wsdl = Assets.getText 'wsdl/DataRecipientOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapRC", service, wsdl
  logger = Winston
  logger.info 'DataRecipientOperationsCallbackService listener started'

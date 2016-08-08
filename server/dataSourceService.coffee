
service =
  DataSourceOperationsCallbackService:
    wsHttpEndpoint:
      ReceiveCatalogueItemConfirmation: (args) ->
        console.log("notification", args);
        args

Meteor.startup () ->
  wsdl = Assets.getText 'wsdl/DataSourceOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapSC", service, wsdl


service =
  DataRecipientOperationsCallbackService:
    wsHttpEndpoint:
      ReceiveCatalogueItemNotification: (args) ->
        console.log("notification")
        console.log(JSON.stringify(args, null, 2))
        #determine correct output
        args
      ReceiveCatalogueItemHierarchicalWithdrawal: (args) ->
        console.log("withdrawal")
        console.log(JSON.stringify(args, null, 2))
        #determine correct output
        args

Meteor.startup () ->
  wsdl = Assets.getText 'wsdl/DataRecipientOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapRC", service, wsdl

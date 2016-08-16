
@GS1 =
  endpoints:
    dataRecipient: Meteor.settings.endpoints.dataRecipient
    dataSource: Meteor.settings.endpoints.dataSource
  gln:
    fooducer: 5790002328275
    GS1: 5790000000029
  messageTypes:
    catalogItemSubscription: "catalogItemSubscription"
    requestForCatalogItemNotification: "requestForCatalogItemNotification"
    catalogItemConfirmation: "catalogItemConfirmation"
  getHeader: (type, multiple = false) ->
    HeaderVersion: "1.0"
    Sender:
      Identifier:
        attributes:
          Authority: "GS1"
        $value: @gln.fooducer
    Receiver:
      Identifier:
        attributes:
          Authority: "GS1"
        $value: @gln.GS1
    DocumentIdentification:
      Standard: "GS1"
      TypeVersion: "3.1"
      InstanceIdentifier: "Fooducer¤Message¤" + uuid.v4()
      Type: type
      MulpleType: multiple
      CreationDateAndTime: new Date()

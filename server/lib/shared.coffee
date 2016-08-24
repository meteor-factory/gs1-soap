process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';

@GS1 =
  endpoints:
    dataRecipient: Meteor.settings.endpoints.dataRecipient
    dataSource: Meteor.settings.endpoints.dataSource
  gln:
    fooducer: "5790002328275"
    GS1: "5790000000029"
  messageTypes:
    catalogueItemNotification: "catalogueItemNotification"
    catalogueItemHierarchicalWithdrawal: "catalogueItemHierarchicalWithdrawal"
    catalogueItemConfirmation: "CatalogueItemConfirmation"
    catalogueItemSubscription: "CatalogueItemSubscription"
    requestForCatalogueItemNotification: "RequestForCatalogueItemNotification"
  ns:
    stan: "http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
  responseCodes:
    ACCEPTED: "ACCEPTED"
    MODIFIED: "MODIFIED"
    NO_ACTION: "NO_ACTION"
    REJECTED: "REJECTED"
  getPropSafe: (obj, props) ->
    props.reduce ((o, prop) -> if o and o.hasOwnProperty prop then o[prop]), obj
  getHeader: (type, multiple = false) ->
    HeaderVersion:
      attributes:
        xmlns: @ns.stan
      $value: "1.0"
    Sender:
      attributes:
        xmlns: @ns.stan
      Identifier:
        attributes:
          Authority: "GS1"
        $value: @gln.fooducer
    Receiver:
      attributes:
        xmlns: @ns.stan
      Identifier:
        attributes:
          Authority: "GS1"
        $value: @gln.GS1
    DocumentIdentification:
      attributes:
        xmlns: @ns.stan
      Standard: "GS1"
      TypeVersion: "3.1"
      InstanceIdentifier: "Fooducer¤Message¤" + uuid.v4()
      Type: type
      MultipleType: multiple
      CreationDateAndTime: "2016-06-15T07:53:31.174Z" #(new Date().toISOString())
  getResponse: (resp = @responseCode.ACCEPTED) ->
    receiver:
      attributes:
        xmlns: ""
      $value: @gln.fooducer
    sender:
      attributes:
        xmlns: ""
      $value: @gln.GS1
    transactionResponse:
      attributes:
        xmlns: ""
      $value:
        responseStatusCode:
          $value: resp
  logItem: (args) ->
    try
      ts = Date.now()
      filename = Meteor.settings.logItemsPath + "item-#{ts}-request.json"
      json = JSON.stringify args, null, 2
      fs.writeFile filename, json

      if Meteor.settings.logItems
        items = @getPropSafe args, ['catalogueItemNotificationType', 'CatalogueItemNotificationType']
        for item in items
          gtin = @getPropSafe item, ['catalogueItem', 'tradeItem', 'gtin']
          filename = Meteor.settings.logItemsPath + "item-#{ts}-gtin-#{gtin or 'UNKNOWN'}.json"
          console.log filename

          json = JSON.stringify item, null, 2
          fs.writeFile filename, json
  getLogPath: ->
    path = Assets.absoluteFilePath 'logs/.logs'
    path.substr 0, path.length - 5


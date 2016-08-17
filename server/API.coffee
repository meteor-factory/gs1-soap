@API = 
  addSubscription: (gln) ->
    DR.addSubscription gln
  addSubscription: (gln, gtin) ->
    DR.addSubscription gln, gtin
  updateProduct: (product) ->
    DS.updateProduct product
    #todo update product
  listenForItem: (callback) ->
    DRC.addListener callback
  listenForItemValidation: (callback) ->
    DSC.addListener callback
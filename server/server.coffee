
service =
  Hello_Service:
    Hello_Port:
      sayHello: (args) ->
        greeting:
          args.firstName && args.firstName.$value && args.firstName.$value.toUpperCase()
        sender:
          'meteor'
        timestamp:
          Date()

Meteor.startup () ->
  wsdl = Assets.getText 'HelloService.wsdl'
  Soap.listen "/soap", service, wsdl

Meteor.methods(
  'callHello': (msg) ->
    try
      client = Soap.createClient 'http://localhost:8000/wsdl?wsdl'
      result = client.sayHello
        firstName: msg || 'test'
      console.log "result", result
      return result.sender + " - " + result.timestamp
    catch err
      if err.error is 'soap-creation'
        console.log 'SOAP client creation failed', err
      else if err.error is 'soap-method'
        console.log 'SOAP method call failed', err
      else
        console.log 'SOAP unexpected error', err
      throw err

    debugger
)
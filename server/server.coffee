
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
    logger = Winston
    try
      client = Soap.createClient 'http://localhost:8000/wsdl?wsdl'
      result = client.sayHello
        firstName: msg || 'test'
      logger.info "call hello", {msg, result}
      return result.sender + " - " + result.timestamp
    catch err
      logger.error 'call hello failed', {err, msg}
      if err.error is 'soap-creation'
        console.log 'SOAP client creation failed', err
      else if err.error is 'soap-method'
        console.log 'SOAP method call failed', err
      else
        console.log 'SOAP unexpected error', err
      throw err

    debugger
)
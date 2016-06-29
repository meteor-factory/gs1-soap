
service =
  "Hello_Service":
      "Hello_Port":
          sayHello: (args) ->
            greeting:
              args.firstName

Meteor.startup () ->
  wsdl = Assets.getText 'HelloService.wsdl'
  console.log "foo", wsdl, Soap
  Soap.listen "/soap", service, wsdl
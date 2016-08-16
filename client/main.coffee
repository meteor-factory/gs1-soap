Template.hello.onCreated ->
  @counter = new ReactiveVar(0)

Template.hello.helpers
  counter: ->
    Template.instance().counter.get()

Template.hello.events
  'click button.click': (event, instance) ->
    instance.counter.set instance.counter.get() + 1
  'submit form.echo': (event, instance) ->
    event.preventDefault()
    Meteor.call 'echo', event.target.input.value, (error, result) ->
      event.target.output.value = error || result

Template.wsdl.onCreated ->
  @text = new ReactiveVar('init')

Template.wsdl.helpers
  text: ->
    Template.instance().text.get()

Template.wsdl.events
  'click button#test': (event, instance) ->
    Meteor.call 'callHello', (error, result) ->
      console.log 'resp', error, result
      if not error
       instance.text.set result || "test"
  'submit #addSub': (event, instance) ->
    event.preventDefault()
    gln = event.target.gln.value
    gtin = event.target.gtin.value
    Meteor.call 'addSubscription', gln, gtin, (error, result) ->
      event.target.result.value = error || JSON.stringify(result, null, 2)

Template.hello.onCreated ->
  @counter = new ReactiveVar(0)

Template.hello.helpers
  counter: ->
    Template.instance().counter.get()

Template.hello.events
  'click button': (event, instance) ->
    instance.counter.set instance.counter.get() + 1

Template.wsdl.onCreated ->
  @text = new ReactiveVar('init')

Template.wsdl.helpers
  text: ->
    Template.instance().text.get()

Template.wsdl.events
  'click button': (event, instance) ->
    Meteor.call 'callHello', (error, result) ->
      console.log 'resp', error, result
      if not error
       instance.text.set result || "test"
Template.hello.onCreated ->
  @counter = new ReactiveVar(0)

Template.hello.helpers
  counter: ->
    Template.instance().counter.get()

Template.hello.events
  'click button.test': () ->
    Meteor.call 'test'
  'click button.click': (event, instance) ->
    instance.counter.set instance.counter.get() + 1
  'submit form.echo': (event, instance) ->
    event.preventDefault()
    Meteor.call 'echo', event.target.input.value, (error, result) ->
      event.target.output.value = error || result
      val = parseInt event.target.input.value
      if val >= 0
        event.target.input.value = val + 1

Template.gs1.events
  'submit form.add': (event) ->
    console.log("add")
    event.preventDefault()
    Meteor.call 'add', event.target.gln.value, (error, result) ->
      event.target.output.value = error || JSON.stringify result, null, 2
  'submit form.resend': (event) ->
    console.log("resend")
    event.preventDefault()
    Meteor.call 'resend', event.target.gln.value, (error, result) ->
      event.target.output.value = error || JSON.stringify result, null, 2
  'submit form.send': (event) ->
    console.log("send")
    event.preventDefault()
    Meteor.call 'send', event.target.input.value, (error, result) ->
      event.target.output.value = error || JSON.stringify result, null, 2
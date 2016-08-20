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
      val = parseInt event.target.input.value
      if val >= 0
        event.target.input.value = val + 1

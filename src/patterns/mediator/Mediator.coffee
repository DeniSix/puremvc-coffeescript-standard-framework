#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class Mediator extends Notifier
  constructor: (@mediatorName = @NAME, @viewComponent) ->
    super()

  getMediatorName: ->
    @mediatorName

  getViewComponent: ->
    @viewComponent

  setViewComponent: (@viewComponent) ->
    # NOOP

  listNotificationInterests: ->
    []

  handleNotification: (notification) ->
    # NOOP

  onRegister: ->
    # NOOP

  onRemove: ->
    # NOOP

  NAME: 'Mediator'

# Restrict class to `puremvc` puremvc.DefineNamespace
puremvc.DefineNamespace 'puremvc', (exports) ->
  exports.Mediator = Mediator

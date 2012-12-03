#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class Facade
  # Singleton instance
  instance = null

  constructor: ->
    throw new Error(Facade.SINGLETON_MSG) if instance
    @initializeFacade()

  initializeFacade: ->
    @initializeModel()
    @initializeController()
    @initializeView()

  initializeController: ->
    @controller ?= Controller.getInstance()

  initializeModel: ->
    @model ?= Model.getInstance()

  initializeView: ->
    @view ?= View.getInstance()

  registerCommand: (notificationName, commandClassRef) ->
    @controller.registerCommand notificationName, commandClassRef

  removeCommand: (notificationName) ->
    @controller.removeCommand notificationName

  hasCommand: (notificationName) ->
    @controller.hasCommand notificationName

  registerProxy: (proxy) ->
    @model.registerProxy proxy

  retrieveProxy: (proxyName) ->
    @model.retrieveProxy proxyName

  removeProxy: (proxyName) ->
    @model?.removeProxy proxyName

  hasProxy: (proxyName) ->
    @model.hasProxy proxyName

  sendNotification: (notificationName, body, type) ->
    @notifyObservers new Notification(notificationName, body, type)

  notifyObservers: (notification) ->
    @view?.notifyObservers notification

  registerMediator: (mediator) ->
    @view?.registerMediator mediator

  retrieveMediator: (mediatorName) ->
    @view.retrieveMediator mediatorName

  removeMediator: (mediatorName) ->
    @view.removeMediator mediatorName

  hasMediator: (mediatorName) ->
    @view.hasMediator mediatorName

  @getInstance = ->
    instance ?= new Facade()

  # Message Constants
  @SINGLETON_MSG = "Facade Singleton already constructed!"

# Restrict class to `puremvc` namespace
namespace 'puremvc', (exports) ->
  exports.Facade = Facade

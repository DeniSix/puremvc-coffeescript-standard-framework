#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

###
A Singleton `View` implementation.

In PureMVC, the `View` class assumes these responsibilities:

  * Maintain a cache of `Mediator` instances.
  * Provide methods for registering, retrieving, and removing `Mediators`.
  * Notifiying `Mediators` when they are registered or removed.
  * Managing the observer lists for each `Notification` in the application.
  * Providing a method for attaching `Observers` to an `Notification`'s observer list.
  * Providing a method for broadcasting an `Notification`.
  * Notifying the `Observers` of a given `Notification` when it broadcast.
###
class View
  # Singleton instance
  instance = null
  # Mapping of Mediator names to Mediator instances
  mediatorMap: null
  # Mapping of Notification names to Observer lists
  observerMap: null

  constructor: ->
    throw new Error(View.SINGLETON_MSG) if instance
    @mediatorMap = {}
    @observerMap = {}
    @initializeView()

  initializeView: ->
    # NOOP

  registerObserver: (notificationName, observer) ->
    @observerMap[notificationName] ?= []
    @observerMap[notificationName].push observer

  notifyObservers: (notification) ->
    observers_ref = @observerMap[notification.getName()]
    if observers_ref
      observers = observers_ref[0..]
      observer.notifyObserver notification for observer in observers

  removeObserver: (notificationName, notifyContext) ->
    observers = observerMap[notificationName]
    for observer, i in observers
      if observer.compareNotifyContext notifyContext
        observers.splice i, 1
        break
    delete @observerMap[name] if observers.length <= 0

  registerMediator: (mediator) ->
    return null if @mediatorMap[mediator.getMediatorName()]
    @mediatorMap[mediator.getMediatorName()] = mediator
    interests = mediator.listNotificationInterests()
    if interests.length > 0
      observer = new Observer mediator.handleNotification, mediator
      @registerObserver interest, observer for interest in interests
    mediator.onRegister()

  retrieveMediator: (mediatorName) ->
    @mediatorMap[mediatorName] or null

  removeMediator: (mediatorName) ->
    mediator = @mediatorMap[mediatorName]
    if mediator
      @removeObserver interest, mediator for interest in mediator.listNotificationInterests()
      delete @mediatorMap[mediatorName]
      mediator.onRemove()
    mediator

  hasMediator: (mediatorName) ->
    @mediatorMap[mediatorName]?

  @getInstance = ->
    instance ?= new View()

  # Message Constants
  @SINGLETON_MSG = "View Singleton already constructed!"

# Restrict class to `puremvc` puremvc.DefineNamespace
puremvc.DefineNamespace 'puremvc', (exports) ->
  exports.View = View

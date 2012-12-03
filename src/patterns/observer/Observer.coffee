#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class Observer
  facade: null

  constructor: (notifyMethod, notifyContext) ->
    @setNotifyMethod notifyMethod
    @setNotifyContext notifyContext

  setNotifyMethod: (@notifyMethod) ->
    # NOOP

  setNotifyContext: (@notifyContext) ->
    # NOOP

  getNotifyMethod: ->
    @notifyMethod

  getNotifyContext: ->
    @notifyContext

  notifyObserver: (notification) ->
    @getNotifyMethod().call @getNotifyContext(), notification

  compareNotifyContext: (object) ->
    obj is @getNotifyContext()

# Restrict class to `puremvc` namespace
namespace 'puremvc', (exports) ->
  exports.Observer = Observer

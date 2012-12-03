#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class Notifier
  facade: null

  constructor: ->
    @facade = Facade.getInstance()

  sendNotification: (notificationName, body, type) ->
    @facade.sendNotification notificationName, body, type

# Restrict class to `puremvc` namespace
namespace 'puremvc', (exports) ->
  exports.Notifier = Notifier

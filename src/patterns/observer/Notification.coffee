#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class Notification
  constructor: (@name, @body, @type) ->

  getName: ->
    @name

  getBody: ->
    @body

  setBody: (@body) ->
    # NOOP

  getType: () ->
    @type

  setType: (@type) ->
    # NOOP

  toString: ->
    "Notification Name: #{name}\nBody: #{@body or null}\nType: #{@type or null}"

# Restrict class to `puremvc` puremvc.DefineNamespace
puremvc.DefineNamespace 'puremvc', (exports) ->
  exports.Notification = Notification

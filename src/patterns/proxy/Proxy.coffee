#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class Proxy extends Notifier
  constructor: (@proxyName = @NAME, @data) ->
    super()

  getProxyName: ->
    @proxyName

  setData: (@data) ->
    # NOOP

  getData: ->
    @data

  onRegister: ->
    # NOOP

  onRemove: ->
    # NOOP

  NAME: 'Proxy'

# Restrict class to `puremvc` namespace
namespace 'puremvc', (exports) ->
  exports.Proxy = Proxy

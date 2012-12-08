#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

DefineNamespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top


# Restrict function to `puremvc` namespace
DefineNamespace 'puremvc', (exports) ->
  exports.DefineNamespace = DefineNamespace

#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class SimpleCommand extends Notifier
  execute: (notification) ->
    # NOOP

# Restrict class to `puremvc` namespace
namespace 'puremvc', (exports) ->
  exports.SimpleCommand = SimpleCommand

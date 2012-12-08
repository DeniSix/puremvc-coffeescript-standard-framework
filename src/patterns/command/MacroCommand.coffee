#
# PureMVC CoffeScript implementation by Denis Shemanaev <idenisix@gmail.com>
#
# PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
# Your reuse is governed by the Creative Commons Attribution 3.0 United States License
#

class MacroCommand extends Notifier
  subCommands: null

  constructor: ->
    super()
    @subCommands = []
    @initializeMacroCommand()

  initializeMacroCommand: ->
    # NOOP

  addSubCommand: (commandClassRef) ->
    @subCommands.push commandClassRef

  execute: (notification) ->
    new commandClassRef().execute notification for commandClassRef in @subCommands
    null

# Restrict class to `puremvc` puremvc.DefineNamespace
puremvc.DefineNamespace 'puremvc', (exports) ->
  exports.MacroCommand = MacroCommand

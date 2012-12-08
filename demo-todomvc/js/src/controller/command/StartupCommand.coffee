###
@author Mike Britton

@class StartupCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class StartupCommand extends puremvc.MacroCommand

  # INSTANCE MEMBERS

  ###
  Add the sub-commands for this MacroCommand
  @override
  ###
  initializeMacroCommand: ->
    @addSubCommand todomvc.controller.command.PrepControllerCommand
    @addSubCommand todomvc.controller.command.PrepModelCommand
    @addSubCommand todomvc.controller.command.PrepViewCommand

puremvc.DefineNamespace 'todomvc.controller.command', (exports) ->
  exports.StartupCommand = StartupCommand

###
@author Mike Britton

@class PrepViewCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class PrepViewCommand extends puremvc.SimpleCommand

  # INSTANCE MEMBERS

  ###
  Register Mediators with the View
  @override
  ###
  execute: (note) ->
    @facade.registerMediator new todomvc.view.mediator.TodoFormMediator()
    @facade.registerMediator new todomvc.view.mediator.RoutesMediator()

puremvc.DefineNamespace 'todomvc.controller.command', (exports) ->
  exports.PrepViewCommand = PrepViewCommand

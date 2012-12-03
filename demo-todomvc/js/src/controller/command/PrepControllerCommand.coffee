###
@author Mike Britton, Cliff Hall

@class PrepControllerCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class PrepControllerCommand extends puremvc.SimpleCommand
  # INSTANCE MEMBERS

  ###
  Register Commands with the Controller
  @override
  ###
  execute: (note) ->

    # This registers multiple notes to a single command which performs different logic based on the note name.
    # In a more complex app, we'd usually be registering a different command to each notification name.
    @facade.registerCommand todomvc.AppConstants::ADD_TODO, todomvc.controller.command.TodoCommand
    @facade.registerCommand todomvc.AppConstants::REMOVE_TODOS_COMPLETED, todomvc.controller.command.TodoCommand
    @facade.registerCommand todomvc.AppConstants::DELETE_TODO, todomvc.controller.command.TodoCommand
    @facade.registerCommand todomvc.AppConstants::UPDATE_TODO, todomvc.controller.command.TodoCommand
    @facade.registerCommand todomvc.AppConstants::TOGGLE_TODO_STATUS, todomvc.controller.command.TodoCommand
    @facade.registerCommand todomvc.AppConstants::FILTER_TODOS, todomvc.controller.command.TodoCommand

namespace 'todomvc.controller.command', (exports) ->
  exports.PrepControllerCommand = PrepControllerCommand

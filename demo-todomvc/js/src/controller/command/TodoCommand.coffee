###
@author Mike Britton, Cliff Hall

@class TodoCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class TodoCommand extends puremvc.SimpleCommand

  # INSTANCE MEMBERS

  ###
  Perform business logic (in this case, based on Notification name)
  @override
  ###
  execute: (note) ->
    proxy = @facade.retrieveProxy(todomvc.model.proxy.TodoProxy::NAME)
    switch note.getName()
      when todomvc.AppConstants::ADD_TODO
        proxy.addTodo note.getBody()
      when todomvc.AppConstants::DELETE_TODO
        proxy.deleteTodo note.getBody()
      when todomvc.AppConstants::UPDATE_TODO
        proxy.updateTodo note.getBody()
      when todomvc.AppConstants::TOGGLE_TODO_STATUS
        proxy.toggleCompleteStatus note.getBody()
      when todomvc.AppConstants::REMOVE_TODOS_COMPLETED
        proxy.removeTodosCompleted()
      when todomvc.AppConstants::FILTER_TODOS
        proxy.filterTodos note.getBody()
      else
        console.log "TodoCommand received an unsupported Notification"

puremvc.DefineNamespace 'todomvc.controller.command', (exports) ->
  exports.TodoCommand = TodoCommand

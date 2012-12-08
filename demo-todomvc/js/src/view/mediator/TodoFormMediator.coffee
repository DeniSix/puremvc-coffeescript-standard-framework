###
@author Mike Britton

@class TodoFormMediator
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class TodoFormMediator extends puremvc.Mediator
  # INSTANCE MEMBERS

  # Notifications this mediator is interested in
  listNotificationInterests: ->
    [todomvc.AppConstants::TODOS_FILTERED]


  # Code to be executed when the Mediator instance is registered with the View
  onRegister: ->
    @setViewComponent new todomvc.view.component.TodoForm
    @viewComponent.addEventListener todomvc.view.event.AppEvents::TOGGLE_COMPLETE, this
    @viewComponent.addEventListener todomvc.view.event.AppEvents::TOGGLE_COMPLETE_ALL, this
    @viewComponent.addEventListener todomvc.view.event.AppEvents::UPDATE_ITEM, this
    @viewComponent.addEventListener todomvc.view.event.AppEvents::DELETE_ITEM, this
    @viewComponent.addEventListener todomvc.view.event.AppEvents::ADD_ITEM, this
    @viewComponent.addEventListener todomvc.view.event.AppEvents::CLEAR_COMPLETED, this


  # Handle events from the view component
  handleEvent: (event) ->
    switch event.type
      when todomvc.view.event.AppEvents::TOGGLE_COMPLETE_ALL
        @sendNotification todomvc.AppConstants::TOGGLE_TODO_STATUS, event.doToggleComplete
      when todomvc.view.event.AppEvents::DELETE_ITEM
        @sendNotification todomvc.AppConstants::DELETE_TODO, event.todoId
      when todomvc.view.event.AppEvents::ADD_ITEM
        @sendNotification todomvc.AppConstants::ADD_TODO, event.todo
      when todomvc.view.event.AppEvents::CLEAR_COMPLETED
        @sendNotification todomvc.AppConstants::REMOVE_TODOS_COMPLETED
      when todomvc.view.event.AppEvents::TOGGLE_COMPLETE, todomvc.view.event.AppEvents::UPDATE_ITEM
        @sendNotification todomvc.AppConstants::UPDATE_TODO, event.todo


  # Handle notifications from other PureMVC actors
  handleNotification: (note) ->
    switch note.getName()
      when todomvc.AppConstants::TODOS_FILTERED
        @viewComponent.setFilteredTodoList note.getBody()

  # STATIC MEMBERS
  NAME: "TodoFormMediator"

puremvc.DefineNamespace 'todomvc.view.mediator', (exports) ->
  exports.TodoFormMediator = TodoFormMediator

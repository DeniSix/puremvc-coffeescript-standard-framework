###
@author Mike Britton, Cliff Hall

@class TodoProxy
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class TodoProxy extends puremvc.Proxy
  # INSTANCE MEMBERS
  todos: []
  stats: {}
  filter: todomvc.AppConstants::FILTER_ALL
  LOCAL_STORAGE: "todos-puremvc"
  onRegister: ->
    @loadData()

  loadData: ->
    storageObject = undefined
    @saveData()  unless localStorage.getItem(@LOCAL_STORAGE)
    storageObject = JSON.parse(localStorage.getItem(@LOCAL_STORAGE))
    @todos = storageObject.todos
    @filter = storageObject.filter
    @computeStats()

  saveData: ->
    storageObject =
      todos: @todos
      filter: @filter

    localStorage.setItem @LOCAL_STORAGE, JSON.stringify(storageObject)

  computeStats: ->
    @stats.totalTodo = @todos.length
    @stats.todoCompleted = @getCompletedCount()
    @stats.todoLeft = @stats.totalTodo - @stats.todoCompleted

  filterTodos: (filter) ->
    i = undefined
    @filter = filter
    @saveData()
    i = @todos.length
    filtered = []

    while i--
      if filter is todomvc.AppConstants::FILTER_ALL
        filtered.push @todos[i]
      else if @todos[i].completed is true and filter is todomvc.AppConstants::FILTER_COMPLETED
        filtered.push @todos[i]
      else filtered.push @todos[i]  if @todos[i].completed is false and filter is todomvc.AppConstants::FILTER_ACTIVE
    @sendNotification todomvc.AppConstants::TODOS_FILTERED,
      todos: filtered
      stats: @stats
      filter: @filter


  todosModified: ->
    @computeStats()
    @filterTodos @filter

  removeTodosCompleted: ->
    i = @todos.length
    @todos.splice i, 1  if @todos[i].completed  while i--
    @todosModified()

  deleteTodo: (id) ->
    i = @todos.length
    @todos.splice i, 1  if @todos[i].id is id  while i--
    @todosModified()

  toggleCompleteStatus: (status) ->
    i = @todos.length
    @todos[i].completed = status  while i--
    @todosModified()

  updateTodo: (todo) ->
    i = @todos.length
    while i--
      if @todos[i].id is todo.id
        @todos[i].title = todo.title
        @todos[i].completed = todo.completed
    @todosModified()

  addTodo: (newTodo) ->
    newTodo.id = @getUuid()
    @todos.push newTodo
    @todosModified()

  getCompletedCount: ->
    i = @todos.length
    completed = 0
    for todo in @todos
      completed++  if todo.completed
    completed

  getUuid: ->
    i = undefined
    random = undefined
    uuid = ""
    i = 0
    while i < 32
      random = Math.random() * 16 | 0
      uuid += "-"  if i is 8 or i is 12 or i is 16 or i is 20
      uuid += ((if i is 12 then 4 else ((if i is 16 then (random & 3 | 8) else random)))).toString(16)
      i++
    uuid

  # CLASS MEMBERS
  NAME: "TodoProxy"

namespace 'todomvc.model.proxy', (exports) ->
  exports.TodoProxy = TodoProxy

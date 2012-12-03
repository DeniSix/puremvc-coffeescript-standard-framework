###
@author Mike Britton, Cliff Hall

@class TodoForm
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class TodoForm
  constructor: (event) ->

    # data
    @todos = []
    @stats = {}
    @filter = ""

    # Fixed DOM elements managed by this view component
    @todoApp = document.querySelector("#todoapp")
    @main = @todoApp.querySelector("#main")
    @toggleAllCheckbox = @todoApp.querySelector("#toggle-all")
    @newTodoField = @todoApp.querySelector("#new-todo")
    @todoList = @todoApp.querySelector("#todo-list")
    @footer = @todoApp.querySelector("#footer")
    @todoCount = @todoApp.querySelector("#todo-count")
    @clearButton = @todoApp.querySelector("#clear-completed")
    @filters = @todoApp.querySelector("#filters")
    @filterAll = @filters.querySelector("#filterAll")
    @filterActive = @filters.querySelector("#filterActive")
    @filterCompleted = @filters.querySelector("#filterCompleted")

    # Event listeners for fixed UI elements
    @newTodoField.component = this
    todomvc.view.event.AppEvents::addEventListener @newTodoField, "keypress", (event) ->
      @component.dispatchAddTodo event  if event.keyCode is todomvc.view.component.TodoForm::ENTER_KEY and @value

    @clearButton.component = this
    todomvc.view.event.AppEvents::addEventListener @clearButton, "click", (event) ->
      @component.dispatchClearCompleted event

    @toggleAllCheckbox.component = this
    todomvc.view.event.AppEvents::addEventListener @toggleAllCheckbox, "change", (event) ->
      @component.dispatchToggleCompleteAll event.target.checked


  # INSTANCE MEMBERS
  ENTER_KEY: 13
  addEventListener: (type, listener, useCapture) ->
    todomvc.view.event.AppEvents::addEventListener @todoApp, type, listener, useCapture

  createEvent: (eventName) ->
    todomvc.view.event.AppEvents::createEvent eventName

  dispatchEvent: (event) ->
    todomvc.view.event.AppEvents::dispatchEvent @todoApp, event

  dispatchToggleComplete: (event) ->
    todo = undefined
    toggleItemCompleteEvent = undefined
    todo = @getTodoById(event.target.getAttribute("data-todo-id"))
    todo.id = event.target.getAttribute("data-todo-id")
    todo.completed = event.target.checked
    toggleItemCompleteEvent = @createEvent(todomvc.view.event.AppEvents::TOGGLE_COMPLETE)
    toggleItemCompleteEvent.todo = todo
    @dispatchEvent toggleItemCompleteEvent

  dispatchToggleCompleteAll: (checked) ->
    toggleCompleteAllEvent = @createEvent(todomvc.view.event.AppEvents::TOGGLE_COMPLETE_ALL)
    toggleCompleteAllEvent.doToggleComplete = checked
    @dispatchEvent toggleCompleteAllEvent

  dispatchClearCompleted: ->
    clearCompleteEvent = @createEvent(todomvc.view.event.AppEvents::CLEAR_COMPLETED)
    @dispatchEvent clearCompleteEvent

  dispatchDelete: (id) ->
    deleteItemEvent = @createEvent(todomvc.view.event.AppEvents::DELETE_ITEM)
    deleteItemEvent.todoId = id
    @dispatchEvent deleteItemEvent

  dispatchAddTodo: (event) ->
    addItemEvent = undefined
    todo = {}
    todo.completed = false
    todo.title = @newTodoField.value.trim()
    return  if todo.title is ""
    addItemEvent = @createEvent(todomvc.view.event.AppEvents::ADD_ITEM)
    addItemEvent.todo = todo
    @dispatchEvent addItemEvent

  dispatchUpdateTodo: (event) ->
    eventType = undefined
    updateItemEvent = undefined
    todo = {}
    todo.id = event.target.id.slice(6)
    todo.title = event.target.value.trim()
    todo.completed = event.target.completed
    eventType = (if (todo.title is "") then todomvc.view.event.AppEvents::DELETE_ITEM else todomvc.view.event.AppEvents::UPDATE_ITEM)
    updateItemEvent = @createEvent(eventType)
    updateItemEvent.todo = todo
    updateItemEvent.todoId = todo.id
    @dispatchEvent updateItemEvent

  setFilteredTodoList: (data) ->
    todo = undefined
    checkbox = undefined
    label = undefined
    deleteLink = undefined
    divDisplay = undefined
    inputEditTodo = undefined
    li = undefined
    i = undefined
    todoId = undefined
    div = undefined
    inputEditTodo = undefined

    # Update instance data
    @todos = data.todos
    @stats = data.stats
    @filter = data.filter

    # Hide main section if no todos
    @main.style.display = (if @stats.totalTodo then "block" else "none")

    # Create Todo list
    @todoList.innerHTML = ""
    @newTodoField.value = ""
    i = 0
    while i < @todos.length
      todo = @todos[i]

      # Create checkbox
      checkbox = document.createElement("input")
      checkbox.className = "toggle"
      checkbox.setAttribute "data-todo-id", todo.id
      checkbox.type = "checkbox"
      checkbox.component = this
      todomvc.view.event.AppEvents::addEventListener checkbox, "change", (event) ->
        @component.dispatchToggleComplete event


      # Create div text
      label = document.createElement("label")
      label.setAttribute "data-todo-id", todo.id
      label.appendChild document.createTextNode(todo.title)

      # Create delete button
      deleteLink = document.createElement("button")
      deleteLink.className = "destroy"
      deleteLink.setAttribute "data-todo-id", todo.id
      deleteLink.component = this
      todomvc.view.event.AppEvents::addEventListener deleteLink, "click", (event) ->
        @component.dispatchDelete event.target.getAttribute("data-todo-id")


      # Create divDisplay
      divDisplay = document.createElement("div")
      divDisplay.className = "view"
      divDisplay.setAttribute "data-todo-id", todo.id
      divDisplay.appendChild checkbox
      divDisplay.appendChild label
      divDisplay.appendChild deleteLink
      todomvc.view.event.AppEvents::addEventListener divDisplay, "dblclick", ->
        todoId = @getAttribute("data-todo-id")
        div = document.getElementById("li_" + todoId)
        inputEditTodo = document.getElementById("input_" + todoId)
        div.className = "editing"
        inputEditTodo.focus()


      # Create todo input
      inputEditTodo = document.createElement("input")
      inputEditTodo.id = "input_" + todo.id
      inputEditTodo.className = "edit"
      inputEditTodo.value = todo.title
      inputEditTodo.completed = todo.completed
      inputEditTodo.component = this
      todomvc.view.event.AppEvents::addEventListener inputEditTodo, "keypress", (event) ->
        @component.dispatchUpdateTodo event  if event.keyCode is todomvc.view.component.TodoForm::ENTER_KEY

      todomvc.view.event.AppEvents::addEventListener inputEditTodo, "blur", (event) ->
        @component.dispatchUpdateTodo event


      # Create Todo ListItem and add to list
      li = document.createElement("li")
      li.id = "li_" + todo.id
      li.appendChild divDisplay
      li.appendChild inputEditTodo
      if todo.completed
        li.className += "complete"
        checkbox.checked = true
      @todoList.appendChild li
      i++

    # Update UI
    @footer.style.display = (if @stats.totalTodo then "block" else "none")
    @updateToggleAllCheckbox()
    @updateClearButton()
    @updateTodoCount()
    @updateFilter()

  getTodoById: (id) ->
    i = undefined
    i = 0
    while i < @todos.length
      return @todos[i]  if @todos[i].id is id
      i++

  updateFilter: ->
    @filterAll.className = (if (@filter is todomvc.AppConstants::FILTER_ALL) then "selected" else "")
    @filterActive.className = (if (@filter is todomvc.AppConstants::FILTER_ACTIVE) then "selected" else "")
    @filterCompleted.className = (if (@filter is todomvc.AppConstants::FILTER_COMPLETED) then "selected" else "")

  updateToggleAllCheckbox: ->
    i = undefined
    checked = (@todos.length > 0)
    i = 0
    while i < @todos.length
      if @todos[i].completed is false
        checked = false
        break
      i++
    @toggleAllCheckbox.checked = checked

  updateClearButton: ->
    @clearButton.style.display = (if (@stats.todoCompleted is 0) then "none" else "block")
    @clearButton.innerHTML = "Clear completed (" + @stats.todoCompleted + ")"

  updateTodoCount: ->
    number = document.createElement("strong")
    text = " " + ((if @stats.todoLeft is 1 then "item" else "items")) + " left"
    number.innerHTML = @stats.todoLeft
    @todoCount.innerHTML = null
    @todoCount.appendChild number
    @todoCount.appendChild document.createTextNode(text)


  # STATIC MEMBERS
  NAME: "TodoForm"

namespace 'todomvc.view.component', (exports) ->
  exports.TodoForm = TodoForm

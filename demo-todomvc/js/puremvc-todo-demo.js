// Generated by CoffeeScript 1.4.0
/*
@author Mike Britton

@class AppConstants
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git

Define the core and notification constants.

PureMVC JS is multi-core, meaning you may have multiple,
named and isolated PureMVC cores. This app only has one.
*/

var AppConstants, AppEvents, Application, PrepControllerCommand, PrepModelCommand, PrepViewCommand, RoutesMediator, StartupCommand, TodoCommand, TodoForm, TodoFormMediator, TodoProxy,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

AppConstants = (function() {

  function AppConstants() {}

  AppConstants.prototype.CORE_NAME = "TodoMVC";

  AppConstants.prototype.STARTUP = "startup";

  AppConstants.prototype.ADD_TODO = "add_todo";

  AppConstants.prototype.DELETE_TODO = "delete_todo";

  AppConstants.prototype.UPDATE_TODO = "update_todo";

  AppConstants.prototype.TOGGLE_TODO_STATUS = "toggle_todo_status";

  AppConstants.prototype.REMOVE_TODOS_COMPLETED = "remove_todos_completed";

  AppConstants.prototype.FILTER_TODOS = "filter_todos";

  AppConstants.prototype.TODOS_FILTERED = "todos_filtered";

  AppConstants.prototype.FILTER_ALL = "all";

  AppConstants.prototype.FILTER_ACTIVE = "active";

  AppConstants.prototype.FILTER_COMPLETED = "completed";

  return AppConstants;

})();

puremvc.DefineNamespace('todomvc', function(exports) {
  return exports.AppConstants = AppConstants;
});

/*
@author Mike Britton, Cliff Hall

@class TodoProxy
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


TodoProxy = (function(_super) {

  __extends(TodoProxy, _super);

  function TodoProxy() {
    return TodoProxy.__super__.constructor.apply(this, arguments);
  }

  TodoProxy.prototype.todos = [];

  TodoProxy.prototype.stats = {};

  TodoProxy.prototype.filter = todomvc.AppConstants.prototype.FILTER_ALL;

  TodoProxy.prototype.LOCAL_STORAGE = "todos-puremvc";

  TodoProxy.prototype.onRegister = function() {
    return this.loadData();
  };

  TodoProxy.prototype.loadData = function() {
    var storageObject;
    storageObject = void 0;
    if (!localStorage.getItem(this.LOCAL_STORAGE)) {
      this.saveData();
    }
    storageObject = JSON.parse(localStorage.getItem(this.LOCAL_STORAGE));
    this.todos = storageObject.todos;
    this.filter = storageObject.filter;
    return this.computeStats();
  };

  TodoProxy.prototype.saveData = function() {
    var storageObject;
    storageObject = {
      todos: this.todos,
      filter: this.filter
    };
    return localStorage.setItem(this.LOCAL_STORAGE, JSON.stringify(storageObject));
  };

  TodoProxy.prototype.computeStats = function() {
    this.stats.totalTodo = this.todos.length;
    this.stats.todoCompleted = this.getCompletedCount();
    return this.stats.todoLeft = this.stats.totalTodo - this.stats.todoCompleted;
  };

  TodoProxy.prototype.filterTodos = function(filter) {
    var filtered, i;
    i = void 0;
    this.filter = filter;
    this.saveData();
    i = this.todos.length;
    filtered = [];
    while (i--) {
      if (filter === todomvc.AppConstants.prototype.FILTER_ALL) {
        filtered.push(this.todos[i]);
      } else if (this.todos[i].completed === true && filter === todomvc.AppConstants.prototype.FILTER_COMPLETED) {
        filtered.push(this.todos[i]);
      } else {
        if (this.todos[i].completed === false && filter === todomvc.AppConstants.prototype.FILTER_ACTIVE) {
          filtered.push(this.todos[i]);
        }
      }
    }
    return this.sendNotification(todomvc.AppConstants.prototype.TODOS_FILTERED, {
      todos: filtered,
      stats: this.stats,
      filter: this.filter
    });
  };

  TodoProxy.prototype.todosModified = function() {
    this.computeStats();
    return this.filterTodos(this.filter);
  };

  TodoProxy.prototype.removeTodosCompleted = function() {
    var i;
    i = this.todos.length;
    if ((function() {
      var _results;
      _results = [];
      while (i--) {
        _results.push(this.todos[i].completed);
      }
      return _results;
    }).call(this)) {
      this.todos.splice(i, 1);
    }
    return this.todosModified();
  };

  TodoProxy.prototype.deleteTodo = function(id) {
    var i;
    i = this.todos.length;
    if ((function() {
      var _results;
      _results = [];
      while (i--) {
        _results.push(this.todos[i].id === id);
      }
      return _results;
    }).call(this)) {
      this.todos.splice(i, 1);
    }
    return this.todosModified();
  };

  TodoProxy.prototype.toggleCompleteStatus = function(status) {
    var i;
    i = this.todos.length;
    while (i--) {
      this.todos[i].completed = status;
    }
    return this.todosModified();
  };

  TodoProxy.prototype.updateTodo = function(todo) {
    var i;
    i = this.todos.length;
    while (i--) {
      if (this.todos[i].id === todo.id) {
        this.todos[i].title = todo.title;
        this.todos[i].completed = todo.completed;
      }
    }
    return this.todosModified();
  };

  TodoProxy.prototype.addTodo = function(newTodo) {
    newTodo.id = this.getUuid();
    this.todos.push(newTodo);
    return this.todosModified();
  };

  TodoProxy.prototype.getCompletedCount = function() {
    var completed, i, todo, _i, _len, _ref;
    i = this.todos.length;
    completed = 0;
    _ref = this.todos;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      todo = _ref[_i];
      if (todo.completed) {
        completed++;
      }
    }
    return completed;
  };

  TodoProxy.prototype.getUuid = function() {
    var i, random, uuid;
    i = void 0;
    random = void 0;
    uuid = "";
    i = 0;
    while (i < 32) {
      random = Math.random() * 16 | 0;
      if (i === 8 || i === 12 || i === 16 || i === 20) {
        uuid += "-";
      }
      uuid += (i === 12 ? 4 : (i === 16 ? random & 3 | 8 : random)).toString(16);
      i++;
    }
    return uuid;
  };

  TodoProxy.prototype.NAME = "TodoProxy";

  return TodoProxy;

})(puremvc.Proxy);

puremvc.DefineNamespace('todomvc.model.proxy', function(exports) {
  return exports.TodoProxy = TodoProxy;
});

/*
@author Cliff Hall

@class AppEvents
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


AppEvents = (function() {

  function AppEvents() {}

  AppEvents.prototype.TOGGLE_COMPLETE_ALL = "toggle_complete_all";

  AppEvents.prototype.TOGGLE_COMPLETE = "toggle_complete";

  AppEvents.prototype.CLEAR_COMPLETED = "clear_completed";

  AppEvents.prototype.DELETE_ITEM = "delete_item";

  AppEvents.prototype.UPDATE_ITEM = "update_item";

  AppEvents.prototype.ADD_ITEM = "add_item";

  AppEvents.prototype.createEvent = function(eventName) {
    var event;
    event = void 0;
    if (document.createEvent) {
      event = document.createEvent("Events");
      event.initEvent(eventName, false, false);
    } else {
      if (document.createEventObject) {
        event = document.createEventObject();
      }
    }
    return event;
  };

  AppEvents.prototype.addEventListener = function(object, type, listener, useCapture) {
    if (object.addEventListener) {
      return object.addEventListener(type, listener, useCapture);
    } else {
      if (object.attachEvent) {
        return object.attachEvent(type, listener);
      }
    }
  };

  AppEvents.prototype.dispatchEvent = function(object, event) {
    if (object.dispatchEvent) {
      return object.dispatchEvent(event);
    } else {
      if (object.fireEvent) {
        return object.fireEvent(event.type, event);
      }
    }
  };

  return AppEvents;

})();

puremvc.DefineNamespace('todomvc.view.event', function(exports) {
  return exports.AppEvents = AppEvents;
});

/*
@author Mike Britton, Cliff Hall

@class TodoForm
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


TodoForm = (function() {

  function TodoForm(event) {
    this.todos = [];
    this.stats = {};
    this.filter = "";
    this.todoApp = document.querySelector("#todoapp");
    this.main = this.todoApp.querySelector("#main");
    this.toggleAllCheckbox = this.todoApp.querySelector("#toggle-all");
    this.newTodoField = this.todoApp.querySelector("#new-todo");
    this.todoList = this.todoApp.querySelector("#todo-list");
    this.footer = this.todoApp.querySelector("#footer");
    this.todoCount = this.todoApp.querySelector("#todo-count");
    this.clearButton = this.todoApp.querySelector("#clear-completed");
    this.filters = this.todoApp.querySelector("#filters");
    this.filterAll = this.filters.querySelector("#filterAll");
    this.filterActive = this.filters.querySelector("#filterActive");
    this.filterCompleted = this.filters.querySelector("#filterCompleted");
    this.newTodoField.component = this;
    todomvc.view.event.AppEvents.prototype.addEventListener(this.newTodoField, "keypress", function(event) {
      if (event.keyCode === todomvc.view.component.TodoForm.prototype.ENTER_KEY && this.value) {
        return this.component.dispatchAddTodo(event);
      }
    });
    this.clearButton.component = this;
    todomvc.view.event.AppEvents.prototype.addEventListener(this.clearButton, "click", function(event) {
      return this.component.dispatchClearCompleted(event);
    });
    this.toggleAllCheckbox.component = this;
    todomvc.view.event.AppEvents.prototype.addEventListener(this.toggleAllCheckbox, "change", function(event) {
      return this.component.dispatchToggleCompleteAll(event.target.checked);
    });
  }

  TodoForm.prototype.ENTER_KEY = 13;

  TodoForm.prototype.addEventListener = function(type, listener, useCapture) {
    return todomvc.view.event.AppEvents.prototype.addEventListener(this.todoApp, type, listener, useCapture);
  };

  TodoForm.prototype.createEvent = function(eventName) {
    return todomvc.view.event.AppEvents.prototype.createEvent(eventName);
  };

  TodoForm.prototype.dispatchEvent = function(event) {
    return todomvc.view.event.AppEvents.prototype.dispatchEvent(this.todoApp, event);
  };

  TodoForm.prototype.dispatchToggleComplete = function(event) {
    var todo, toggleItemCompleteEvent;
    todo = void 0;
    toggleItemCompleteEvent = void 0;
    todo = this.getTodoById(event.target.getAttribute("data-todo-id"));
    todo.id = event.target.getAttribute("data-todo-id");
    todo.completed = event.target.checked;
    toggleItemCompleteEvent = this.createEvent(todomvc.view.event.AppEvents.prototype.TOGGLE_COMPLETE);
    toggleItemCompleteEvent.todo = todo;
    return this.dispatchEvent(toggleItemCompleteEvent);
  };

  TodoForm.prototype.dispatchToggleCompleteAll = function(checked) {
    var toggleCompleteAllEvent;
    toggleCompleteAllEvent = this.createEvent(todomvc.view.event.AppEvents.prototype.TOGGLE_COMPLETE_ALL);
    toggleCompleteAllEvent.doToggleComplete = checked;
    return this.dispatchEvent(toggleCompleteAllEvent);
  };

  TodoForm.prototype.dispatchClearCompleted = function() {
    var clearCompleteEvent;
    clearCompleteEvent = this.createEvent(todomvc.view.event.AppEvents.prototype.CLEAR_COMPLETED);
    return this.dispatchEvent(clearCompleteEvent);
  };

  TodoForm.prototype.dispatchDelete = function(id) {
    var deleteItemEvent;
    deleteItemEvent = this.createEvent(todomvc.view.event.AppEvents.prototype.DELETE_ITEM);
    deleteItemEvent.todoId = id;
    return this.dispatchEvent(deleteItemEvent);
  };

  TodoForm.prototype.dispatchAddTodo = function(event) {
    var addItemEvent, todo;
    addItemEvent = void 0;
    todo = {};
    todo.completed = false;
    todo.title = this.newTodoField.value.trim();
    if (todo.title === "") {
      return;
    }
    addItemEvent = this.createEvent(todomvc.view.event.AppEvents.prototype.ADD_ITEM);
    addItemEvent.todo = todo;
    return this.dispatchEvent(addItemEvent);
  };

  TodoForm.prototype.dispatchUpdateTodo = function(event) {
    var eventType, todo, updateItemEvent;
    eventType = void 0;
    updateItemEvent = void 0;
    todo = {};
    todo.id = event.target.id.slice(6);
    todo.title = event.target.value.trim();
    todo.completed = event.target.completed;
    eventType = (todo.title === "" ? todomvc.view.event.AppEvents.prototype.DELETE_ITEM : todomvc.view.event.AppEvents.prototype.UPDATE_ITEM);
    updateItemEvent = this.createEvent(eventType);
    updateItemEvent.todo = todo;
    updateItemEvent.todoId = todo.id;
    return this.dispatchEvent(updateItemEvent);
  };

  TodoForm.prototype.setFilteredTodoList = function(data) {
    var checkbox, deleteLink, div, divDisplay, i, inputEditTodo, label, li, todo, todoId;
    todo = void 0;
    checkbox = void 0;
    label = void 0;
    deleteLink = void 0;
    divDisplay = void 0;
    inputEditTodo = void 0;
    li = void 0;
    i = void 0;
    todoId = void 0;
    div = void 0;
    inputEditTodo = void 0;
    this.todos = data.todos;
    this.stats = data.stats;
    this.filter = data.filter;
    this.main.style.display = (this.stats.totalTodo ? "block" : "none");
    this.todoList.innerHTML = "";
    this.newTodoField.value = "";
    i = 0;
    while (i < this.todos.length) {
      todo = this.todos[i];
      checkbox = document.createElement("input");
      checkbox.className = "toggle";
      checkbox.setAttribute("data-todo-id", todo.id);
      checkbox.type = "checkbox";
      checkbox.component = this;
      todomvc.view.event.AppEvents.prototype.addEventListener(checkbox, "change", function(event) {
        return this.component.dispatchToggleComplete(event);
      });
      label = document.createElement("label");
      label.setAttribute("data-todo-id", todo.id);
      label.appendChild(document.createTextNode(todo.title));
      deleteLink = document.createElement("button");
      deleteLink.className = "destroy";
      deleteLink.setAttribute("data-todo-id", todo.id);
      deleteLink.component = this;
      todomvc.view.event.AppEvents.prototype.addEventListener(deleteLink, "click", function(event) {
        return this.component.dispatchDelete(event.target.getAttribute("data-todo-id"));
      });
      divDisplay = document.createElement("div");
      divDisplay.className = "view";
      divDisplay.setAttribute("data-todo-id", todo.id);
      divDisplay.appendChild(checkbox);
      divDisplay.appendChild(label);
      divDisplay.appendChild(deleteLink);
      todomvc.view.event.AppEvents.prototype.addEventListener(divDisplay, "dblclick", function() {
        todoId = this.getAttribute("data-todo-id");
        div = document.getElementById("li_" + todoId);
        inputEditTodo = document.getElementById("input_" + todoId);
        div.className = "editing";
        return inputEditTodo.focus();
      });
      inputEditTodo = document.createElement("input");
      inputEditTodo.id = "input_" + todo.id;
      inputEditTodo.className = "edit";
      inputEditTodo.value = todo.title;
      inputEditTodo.completed = todo.completed;
      inputEditTodo.component = this;
      todomvc.view.event.AppEvents.prototype.addEventListener(inputEditTodo, "keypress", function(event) {
        if (event.keyCode === todomvc.view.component.TodoForm.prototype.ENTER_KEY) {
          return this.component.dispatchUpdateTodo(event);
        }
      });
      todomvc.view.event.AppEvents.prototype.addEventListener(inputEditTodo, "blur", function(event) {
        return this.component.dispatchUpdateTodo(event);
      });
      li = document.createElement("li");
      li.id = "li_" + todo.id;
      li.appendChild(divDisplay);
      li.appendChild(inputEditTodo);
      if (todo.completed) {
        li.className += "complete";
        checkbox.checked = true;
      }
      this.todoList.appendChild(li);
      i++;
    }
    this.footer.style.display = (this.stats.totalTodo ? "block" : "none");
    this.updateToggleAllCheckbox();
    this.updateClearButton();
    this.updateTodoCount();
    return this.updateFilter();
  };

  TodoForm.prototype.getTodoById = function(id) {
    var i;
    i = void 0;
    i = 0;
    while (i < this.todos.length) {
      if (this.todos[i].id === id) {
        return this.todos[i];
      }
      i++;
    }
  };

  TodoForm.prototype.updateFilter = function() {
    this.filterAll.className = (this.filter === todomvc.AppConstants.prototype.FILTER_ALL ? "selected" : "");
    this.filterActive.className = (this.filter === todomvc.AppConstants.prototype.FILTER_ACTIVE ? "selected" : "");
    return this.filterCompleted.className = (this.filter === todomvc.AppConstants.prototype.FILTER_COMPLETED ? "selected" : "");
  };

  TodoForm.prototype.updateToggleAllCheckbox = function() {
    var checked, i;
    i = void 0;
    checked = this.todos.length > 0;
    i = 0;
    while (i < this.todos.length) {
      if (this.todos[i].completed === false) {
        checked = false;
        break;
      }
      i++;
    }
    return this.toggleAllCheckbox.checked = checked;
  };

  TodoForm.prototype.updateClearButton = function() {
    this.clearButton.style.display = (this.stats.todoCompleted === 0 ? "none" : "block");
    return this.clearButton.innerHTML = "Clear completed (" + this.stats.todoCompleted + ")";
  };

  TodoForm.prototype.updateTodoCount = function() {
    var number, text;
    number = document.createElement("strong");
    text = " " + (this.stats.todoLeft === 1 ? "item" : "items") + " left";
    number.innerHTML = this.stats.todoLeft;
    this.todoCount.innerHTML = null;
    this.todoCount.appendChild(number);
    return this.todoCount.appendChild(document.createTextNode(text));
  };

  TodoForm.prototype.NAME = "TodoForm";

  return TodoForm;

})();

puremvc.DefineNamespace('todomvc.view.component', function(exports) {
  return exports.TodoForm = TodoForm;
});

/*
@author Cliff Hall

@class RoutesMediator
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


RoutesMediator = (function(_super) {

  __extends(RoutesMediator, _super);

  function RoutesMediator() {
    return RoutesMediator.__super__.constructor.apply(this, arguments);
  }

  RoutesMediator.prototype.router = null;

  RoutesMediator.prototype.onRegister = function() {
    var defaultRoute, options, routes, todoProxy;
    todoProxy = this.facade.retrieveProxy(todomvc.model.proxy.TodoProxy.prototype.NAME);
    defaultRoute = this.getRouteForFilter(todoProxy.filter);
    options = {
      resource: this,
      notfound: this.handleFilterAll
    };
    routes = {
      "/": this.handleFilterAll,
      "/active": this.handleFilterActive,
      "/completed": this.handleFilterCompleted
    };
    this.router = new Router(routes).configure(options);
    return this.router.init(defaultRoute);
  };

  RoutesMediator.prototype.getRouteForFilter = function(filter) {
    var route;
    route = void 0;
    switch (filter) {
      case todomvc.AppConstants.prototype.FILTER_ALL:
        route = "/";
        break;
      case todomvc.AppConstants.prototype.FILTER_ACTIVE:
        route = "/active";
        break;
      case todomvc.AppConstants.prototype.FILTER_COMPLETED:
        route = "/completed";
    }
    return route;
  };

  RoutesMediator.prototype.handleFilterAll = function() {
    return this.resource.facade.sendNotification(todomvc.AppConstants.prototype.FILTER_TODOS, todomvc.AppConstants.prototype.FILTER_ALL);
  };

  RoutesMediator.prototype.handleFilterActive = function() {
    return this.resource.facade.sendNotification(todomvc.AppConstants.prototype.FILTER_TODOS, todomvc.AppConstants.prototype.FILTER_ACTIVE);
  };

  RoutesMediator.prototype.handleFilterCompleted = function() {
    return this.resource.facade.sendNotification(todomvc.AppConstants.prototype.FILTER_TODOS, todomvc.AppConstants.prototype.FILTER_COMPLETED);
  };

  RoutesMediator.prototype.NAME = "RoutesMediator";

  return RoutesMediator;

})(puremvc.Mediator);

puremvc.DefineNamespace('todomvc.view.mediator', function(exports) {
  return exports.RoutesMediator = RoutesMediator;
});

/*
@author Mike Britton

@class TodoFormMediator
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


TodoFormMediator = (function(_super) {

  __extends(TodoFormMediator, _super);

  function TodoFormMediator() {
    return TodoFormMediator.__super__.constructor.apply(this, arguments);
  }

  TodoFormMediator.prototype.listNotificationInterests = function() {
    return [todomvc.AppConstants.prototype.TODOS_FILTERED];
  };

  TodoFormMediator.prototype.onRegister = function() {
    this.setViewComponent(new todomvc.view.component.TodoForm);
    this.viewComponent.addEventListener(todomvc.view.event.AppEvents.prototype.TOGGLE_COMPLETE, this);
    this.viewComponent.addEventListener(todomvc.view.event.AppEvents.prototype.TOGGLE_COMPLETE_ALL, this);
    this.viewComponent.addEventListener(todomvc.view.event.AppEvents.prototype.UPDATE_ITEM, this);
    this.viewComponent.addEventListener(todomvc.view.event.AppEvents.prototype.DELETE_ITEM, this);
    this.viewComponent.addEventListener(todomvc.view.event.AppEvents.prototype.ADD_ITEM, this);
    return this.viewComponent.addEventListener(todomvc.view.event.AppEvents.prototype.CLEAR_COMPLETED, this);
  };

  TodoFormMediator.prototype.handleEvent = function(event) {
    switch (event.type) {
      case todomvc.view.event.AppEvents.prototype.TOGGLE_COMPLETE_ALL:
        return this.sendNotification(todomvc.AppConstants.prototype.TOGGLE_TODO_STATUS, event.doToggleComplete);
      case todomvc.view.event.AppEvents.prototype.DELETE_ITEM:
        return this.sendNotification(todomvc.AppConstants.prototype.DELETE_TODO, event.todoId);
      case todomvc.view.event.AppEvents.prototype.ADD_ITEM:
        return this.sendNotification(todomvc.AppConstants.prototype.ADD_TODO, event.todo);
      case todomvc.view.event.AppEvents.prototype.CLEAR_COMPLETED:
        return this.sendNotification(todomvc.AppConstants.prototype.REMOVE_TODOS_COMPLETED);
      case todomvc.view.event.AppEvents.prototype.TOGGLE_COMPLETE:
      case todomvc.view.event.AppEvents.prototype.UPDATE_ITEM:
        return this.sendNotification(todomvc.AppConstants.prototype.UPDATE_TODO, event.todo);
    }
  };

  TodoFormMediator.prototype.handleNotification = function(note) {
    switch (note.getName()) {
      case todomvc.AppConstants.prototype.TODOS_FILTERED:
        return this.viewComponent.setFilteredTodoList(note.getBody());
    }
  };

  TodoFormMediator.prototype.NAME = "TodoFormMediator";

  return TodoFormMediator;

})(puremvc.Mediator);

puremvc.DefineNamespace('todomvc.view.mediator', function(exports) {
  return exports.TodoFormMediator = TodoFormMediator;
});

/*
@author Mike Britton

@class StartupCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


StartupCommand = (function(_super) {

  __extends(StartupCommand, _super);

  function StartupCommand() {
    return StartupCommand.__super__.constructor.apply(this, arguments);
  }

  /*
    Add the sub-commands for this MacroCommand
    @override
  */


  StartupCommand.prototype.initializeMacroCommand = function() {
    this.addSubCommand(todomvc.controller.command.PrepControllerCommand);
    this.addSubCommand(todomvc.controller.command.PrepModelCommand);
    return this.addSubCommand(todomvc.controller.command.PrepViewCommand);
  };

  return StartupCommand;

})(puremvc.MacroCommand);

puremvc.DefineNamespace('todomvc.controller.command', function(exports) {
  return exports.StartupCommand = StartupCommand;
});

/*
@author Mike Britton, Cliff Hall

@class PrepControllerCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


PrepControllerCommand = (function(_super) {

  __extends(PrepControllerCommand, _super);

  function PrepControllerCommand() {
    return PrepControllerCommand.__super__.constructor.apply(this, arguments);
  }

  /*
    Register Commands with the Controller
    @override
  */


  PrepControllerCommand.prototype.execute = function(note) {
    this.facade.registerCommand(todomvc.AppConstants.prototype.ADD_TODO, todomvc.controller.command.TodoCommand);
    this.facade.registerCommand(todomvc.AppConstants.prototype.REMOVE_TODOS_COMPLETED, todomvc.controller.command.TodoCommand);
    this.facade.registerCommand(todomvc.AppConstants.prototype.DELETE_TODO, todomvc.controller.command.TodoCommand);
    this.facade.registerCommand(todomvc.AppConstants.prototype.UPDATE_TODO, todomvc.controller.command.TodoCommand);
    this.facade.registerCommand(todomvc.AppConstants.prototype.TOGGLE_TODO_STATUS, todomvc.controller.command.TodoCommand);
    return this.facade.registerCommand(todomvc.AppConstants.prototype.FILTER_TODOS, todomvc.controller.command.TodoCommand);
  };

  return PrepControllerCommand;

})(puremvc.SimpleCommand);

puremvc.DefineNamespace('todomvc.controller.command', function(exports) {
  return exports.PrepControllerCommand = PrepControllerCommand;
});

/*
@author Mike Britton

@class PrepModelCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


PrepModelCommand = (function(_super) {

  __extends(PrepModelCommand, _super);

  function PrepModelCommand() {
    return PrepModelCommand.__super__.constructor.apply(this, arguments);
  }

  /*
    Register Proxies with the Model
    @override
  */


  PrepModelCommand.prototype.execute = function(note) {
    return this.facade.registerProxy(new todomvc.model.proxy.TodoProxy());
  };

  return PrepModelCommand;

})(puremvc.SimpleCommand);

puremvc.DefineNamespace('todomvc.controller.command', function(exports) {
  return exports.PrepModelCommand = PrepModelCommand;
});

/*
@author Mike Britton

@class PrepViewCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


PrepViewCommand = (function(_super) {

  __extends(PrepViewCommand, _super);

  function PrepViewCommand() {
    return PrepViewCommand.__super__.constructor.apply(this, arguments);
  }

  /*
    Register Mediators with the View
    @override
  */


  PrepViewCommand.prototype.execute = function(note) {
    this.facade.registerMediator(new todomvc.view.mediator.TodoFormMediator());
    return this.facade.registerMediator(new todomvc.view.mediator.RoutesMediator());
  };

  return PrepViewCommand;

})(puremvc.SimpleCommand);

puremvc.DefineNamespace('todomvc.controller.command', function(exports) {
  return exports.PrepViewCommand = PrepViewCommand;
});

/*
@author Mike Britton, Cliff Hall

@class TodoCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


TodoCommand = (function(_super) {

  __extends(TodoCommand, _super);

  function TodoCommand() {
    return TodoCommand.__super__.constructor.apply(this, arguments);
  }

  /*
    Perform business logic (in this case, based on Notification name)
    @override
  */


  TodoCommand.prototype.execute = function(note) {
    var proxy;
    proxy = this.facade.retrieveProxy(todomvc.model.proxy.TodoProxy.prototype.NAME);
    switch (note.getName()) {
      case todomvc.AppConstants.prototype.ADD_TODO:
        return proxy.addTodo(note.getBody());
      case todomvc.AppConstants.prototype.DELETE_TODO:
        return proxy.deleteTodo(note.getBody());
      case todomvc.AppConstants.prototype.UPDATE_TODO:
        return proxy.updateTodo(note.getBody());
      case todomvc.AppConstants.prototype.TOGGLE_TODO_STATUS:
        return proxy.toggleCompleteStatus(note.getBody());
      case todomvc.AppConstants.prototype.REMOVE_TODOS_COMPLETED:
        return proxy.removeTodosCompleted();
      case todomvc.AppConstants.prototype.FILTER_TODOS:
        return proxy.filterTodos(note.getBody());
      default:
        return console.log("TodoCommand received an unsupported Notification");
    }
  };

  return TodoCommand;

})(puremvc.SimpleCommand);

puremvc.DefineNamespace('todomvc.controller.command', function(exports) {
  return exports.TodoCommand = TodoCommand;
});

/*
@author Mike Britton

@class todomvc.Application
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
*/


Application = (function() {

  function Application() {
    this.facade.registerCommand(todomvc.AppConstants.prototype.STARTUP, todomvc.controller.command.StartupCommand);
    this.facade.sendNotification(todomvc.AppConstants.prototype.STARTUP);
  }

  Application.prototype.STARTUP = "startup";

  Application.prototype.facade = puremvc.Facade.getInstance();

  return Application;

})();

puremvc.DefineNamespace('todomvc', function(exports) {
  return exports.Application = Application;
});

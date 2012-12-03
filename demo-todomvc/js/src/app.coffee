###
@author Mike Britton

@class todomvc.Application
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class Application
  constructor: ->

    # register the startup command and trigger it.
    @facade.registerCommand todomvc.AppConstants::STARTUP, todomvc.controller.command.StartupCommand
    @facade.sendNotification todomvc.AppConstants::STARTUP

  # INSTANCE MEMBERS

  # Define the startup notification name
  STARTUP: "startup"

  # Get an instance of the PureMVC Facade. This creates the Model, View, and Controller instances.
  facade: puremvc.Facade.getInstance()

namespace 'todomvc', (exports) ->
  exports.Application = Application


class Controller
  # Singleton instance
  instance = null
  # Local reference to view
  view: null
  # Mapping of Notification names to Command Class references
  commandMap: null

  constructor: ->
    throw new Error(Controller.SINGLETON_MSG) if instance
    @commandMap = {}
    @initializeController()

  initializeController: ->
    @view = View.getInstance()

  executeCommand: (note) ->
    commandClassRef = @commandMap[note.getName()]
    if commandClassRef
      command = new commandClassRef()
      command.execute note if command.execute

  registerCommand: (notificationName, commandClassRef) ->
    @view.registerObserver notificationName, new Observer @executeCommand, this if not @commandMap[notificationName]?
    @commandMap[notificationName] = commandClassRef

  hasCommand: (notificationName) ->
    @commandMap[notificationName]?

  removeCommand: (notificationName) ->
    @view.removeObserver name, this if @hasCommand notificationName

  @getInstance = ->
    instance ?= new Controller()

  # Message Constants
  @SINGLETON_MSG = "Controller Singleton already constructed!"

# Restrict class to `puremvc` puremvc.DefineNamespace
puremvc.DefineNamespace 'puremvc', (exports) ->
  exports.Controller = Controller

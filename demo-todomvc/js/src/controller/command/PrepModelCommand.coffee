###
@author Mike Britton

@class PrepModelCommand
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class PrepModelCommand extends puremvc.SimpleCommand

  # INSTANCE MEMBERS

  ###
  Register Proxies with the Model
  @override
  ###
  execute: (note) ->
    @facade.registerProxy new todomvc.model.proxy.TodoProxy()

puremvc.DefineNamespace 'todomvc.controller.command', (exports) ->
  exports.PrepModelCommand = PrepModelCommand

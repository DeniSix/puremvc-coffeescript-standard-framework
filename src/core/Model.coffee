
class Model
  # Singleton instance
  instance = null
  # Mapping of proxyNames to IProxy instances
  proxyMap: null

  constructor: ->
    throw new Error(Model.SINGLETON_MSG) if instance
    @proxyMap = {}
    @initializeModel()

  initializeModel: ->
    # noop

  registerProxy: (proxy) ->
    @proxyMap[proxy.getProxyName()] = proxy
    proxy.onRegister()

  retrieveProxy: (proxyName) ->
    @proxyMap[proxyName] or null

  hasProxy: (proxyName) ->
    @proxyMap[proxyName]?

  removeProxy: (proxyName) ->
    proxy = @proxyMap[proxyName]
    return null unless proxy
    delete @proxyMap[proxyName]
    proxy.onRemove()
    proxy

  @getInstance = ->
    instance ?= new Model()

  # Message Constants
  @SINGLETON_MSG = "Model Singleton already constructed!"

# Restrict class to `puremvc` namespace
namespace 'puremvc', (exports) ->
  exports.Model = Model

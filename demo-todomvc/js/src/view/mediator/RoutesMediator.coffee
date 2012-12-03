###
@author Cliff Hall

@class RoutesMediator
@link https://github.com/PureMVC/puremvc-js-demo-todomvc.git
###
class RoutesMediator extends puremvc.Mediator

  # INSTANCE MEMBERS

  # the router (Flatirion Director)
  router: null

  # setup the routes when mediator is registered
  onRegister: ->
    todoProxy = @facade.retrieveProxy(todomvc.model.proxy.TodoProxy::NAME)
    defaultRoute = @getRouteForFilter(todoProxy.filter)
    options =
      resource: this
      notfound: @handleFilterAll

    routes =
      "/": @handleFilterAll
      "/active": @handleFilterActive
      "/completed": @handleFilterCompleted

    @router = new Router(routes).configure(options)
    @router.init defaultRoute

  getRouteForFilter: (filter) ->
    route = undefined
    switch filter
      when todomvc.AppConstants::FILTER_ALL
        route = "/"
      when todomvc.AppConstants::FILTER_ACTIVE
        route = "/active"
      when todomvc.AppConstants::FILTER_COMPLETED
        route = "/completed"
    route


  # route handlers
  handleFilterAll: ->
    @resource.facade.sendNotification todomvc.AppConstants::FILTER_TODOS, todomvc.AppConstants::FILTER_ALL

  handleFilterActive: ->
    @resource.facade.sendNotification todomvc.AppConstants::FILTER_TODOS, todomvc.AppConstants::FILTER_ACTIVE

  handleFilterCompleted: ->
    @resource.facade.sendNotification todomvc.AppConstants::FILTER_TODOS, todomvc.AppConstants::FILTER_COMPLETED

  # STATIC MEMBERS
  NAME: "RoutesMediator"

namespace 'todomvc.view.mediator', (exports) ->
  exports.RoutesMediator = RoutesMediator

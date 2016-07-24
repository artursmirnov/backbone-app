Backbone = require 'backbone'

LayoutView = require 'views/LayoutView'

Router = Backbone.Router.extend

  routes:
    '': 'indexRoute'
    'edit': 'editRoute'

  indexRoute: ->
    @layout.triggerMethod 'show:user:info'

  editRoute: ->
    @layout.triggerMethod 'show:edit:form'

  initialize: ->
    @layout = new LayoutView
    @layout.render()

module.exports =

  start: ->
    new Router
    Backbone.history.start()

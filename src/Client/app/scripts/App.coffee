Marionette = require 'backbone.marionette'

Router = require 'Router'

module.exports = Marionette.Application.extend

  onStart: ->
    Router.start()

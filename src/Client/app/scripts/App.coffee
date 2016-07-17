Marionette = require 'backbone.marionette'

module.exports = Marionette.Application.extend

  regions:
    app: '#app'

  initialize: ->
    @on 'start', =>
      @getRegion('app').show();

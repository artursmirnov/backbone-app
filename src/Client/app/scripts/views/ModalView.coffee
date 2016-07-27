Marionette = require 'backbone.marionette'

module.exports = Marionette.LayoutView.extend
  template: '#modal-template'

  title: ''
  body: null

  regions:
    body: '.js-modal-body'

  initialize: (options) ->
    bodyView = options.bodyView
    if bodyView instanceof Marionette.View
      @body = bodyView
      @title = bodyView.title || ''

  # TODO attach to body

  serializeData: ->
    title: @title

  onRender: ->
    @getRegion('body').show @body

  open: ->
    debugger

  close: ->
    debugger

Marionette = require 'backbone.marionette'

module.exports = Marionette.LayoutView.extend
  template: '#modal-template'

  title: ''
  body: null

  primaryActionTitle: 'Save'
  secondaryActionTitle: 'Cancel'

  regions:
    body: '.js-modal-body'

  ui:
    primaryAction: '.js-primary-action'
    secondaryAction: '.js-secondary-action'

  triggers:
    'click @ui.primaryAction': 'action:primary'
    'click @ui.secondaryAction': 'action:secondary'

  initialize: (options) ->
    options = options || {}

    bodyView = options.bodyView
    if bodyView instanceof Marionette.View
      @body = bodyView
      @title = bodyView.title || ''

    @primaryActionTitle = options.primaryActionTitle || @primaryActionTitle
    @secondaryActionTitle = options.secondaryActionTitle || @secondaryActionTitle

  serializeData: ->
    title: @title
    primaryActionTitle: @primaryActionTitle
    secondaryActionTitle: @secondaryActionTitle

  onRender: ->
    @getRegion('body').show @body

  onActionSecondary: ->
    @close()

  open: ->
    @trigger 'open'

  close: ->
    @trigger 'close'

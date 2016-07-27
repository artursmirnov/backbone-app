Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

Router = require 'Router'

module.exports = Marionette.ItemView.extend
  template: false

  ui:
    editButton: '.js-edit-button'

  events:
    'click @ui.editButton': 'openEditForm'

  openEditForm: ->
    Backbone.history.navigate 'edit', trigger: true


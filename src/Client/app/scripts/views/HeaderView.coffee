Marionette = require 'backbone.marionette'

module.exports = Marionette.ItemView.extend
  template: false

  ui:
    editButton: '.js-edit-button'

  events:
    'click @ui.editButton': 'openEditForm'

  openEditForm: ->
    console.log 'Opened edit form'


Marionette = require 'backbone.marionette'

module.exports = Marionette.ItemView.extend
  template: '#edit-form-template'
  title: 'Edit'

  ui:
    textareas: 'textarea'

  events:
    'input @ui.textareas': 'resizeTextarea'

  resizeTextarea: ->
    @ui.textareas.each ->
      @style.height = 'auto'
      @style.height = @scrollHeight + 'px'

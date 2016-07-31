Marionette = require 'backbone.marionette'
moment = require 'moment'

timezoneOffset = new Date().getTimezoneOffset() * 60000

module.exports = Marionette.ItemView.extend
  template: '#edit-form-template'
  title: 'Edit'

  ui:
    textareas: 'textarea'
    birthday: '.js-user-birthday'

  events:
    'input @ui.textareas': 'resizeTextarea'
    'focus @ui.birthday': 'transformBirthdayToDate'
    'blur @ui.birthday': 'transformBirthdayToText'

  resizeTextarea: ->
    @ui.textareas.each ->
      @style.height = 'auto'
      @style.height = @scrollHeight + 'px'

  transformBirthdayToDate: ->
    value = moment(@ui.birthday.val() or undefined, 'LL').subtract(timezoneOffset).toDate()
    @ui.birthday.css(lineHeight: 'inherit').attr(type: 'date')[0].valueAsDate = value

  transformBirthdayToText: ->
    value = if @ui.birthday.val() then moment(@ui.birthday.val()).format('LL') else ''
    @ui.birthday.attr(type: 'text').val(value).trigger('input')

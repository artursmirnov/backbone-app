Marionette = require 'backbone.marionette'
moment = require 'moment'

timezoneOffset = new Date().getTimezoneOffset() * 60000

module.exports = Marionette.ItemView.extend
  template: '#edit-form-template'
  title: 'Edit'

  ui:
    textareas: 'textarea'
    name: '.js-user-name'
    birthday: '.js-user-birthday'
    email: '.js-user-email'
    site: '.js-user-site'
    phone: '.js-user-phone'
    skill: '.js-user-skill'
    password: '.js-user-password'
    confirm: '.js-user-password-confirm'
    about: '.js-user-about'
    genderMale: '.js-user-gender-male'
    genderFemale: '.js-user-gender-female'


  events:
    'input @ui.textareas': 'resizeTextarea'
    'focus @ui.birthday': 'transformBirthdayToDate'
    'blur @ui.birthday': 'transformBirthdayToText'
    'click @ui.genderMale': 'setMale'
    'click @ui.genderFemale': 'setFemale'
    'change input': 'updateModel'
    'change textarea': 'updateModel'

  templateHelpers: ->
    isMale: @model.isMale()
    isFemale: @model.isFemale()

  modelEvents:
    change: 'render'

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

  setMale: ->
    @model.setMale()

  setFemale: ->
    @model.setFemale()

  updateModel: ->
    @model.deserialize
      name: @ui.name.val()
      birthday: @ui.birthday.val()
      email: @ui.email.val()
      siteUrl: @ui.site.val()
      phone: @ui.phone.val()
      skill: @ui.skill.val()
      about: @ui.about.val()

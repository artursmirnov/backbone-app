Marionette = require 'backbone.marionette'

ERROR_STATE_CLASS_NAME = 'validation-error'
SELECTED_GENDER_CLASS_NAME = 'selected'
FIELD_CLASS_NAME = 'js-field'

module.exports = Marionette.ItemView.extend
  template: '#edit-form-template'
  title: 'Edit'

  ui:
    textareas: 'textarea'
    token: '#user__token'
    name: '.js-user-name'
    birthday: '.js-user-birthday'
    email: '.js-user-email'
    siteUrl: '.js-user-site'
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
    birthdayTitle: @model.getBirthdayTitle()

  modelEvents:
    change: 'modelChanged'
    invalid: 'setErrors'
    valid: 'clearErrors'

  modelChanged: ->
    unless @model.changed?.birthday then @updateView()

  onRender: ->
    @model.set '_token', @ui.token.val()
    @_switchGenderField()
    setTimeout =>
      @resizeTextarea()
    , 0

  resizeTextarea: ->
    @ui.textareas.each ->
      @style.height = 'auto'
      @style.height = @scrollHeight + 'px'

  transformBirthdayToDate: ->
    @ui.birthday.val('').css(lineHeight: 'inherit').attr(type: 'date')[0].valueAsDate = @model.get 'birthday'

  transformBirthdayToText: ->
    @updateModel()
    @ui.birthday.attr(type: 'text').val(@model.getBirthdayTitle()).trigger('input')

  setMale: ->
    @model.setMale()

  setFemale: ->
    @model.setFemale()

  setErrors: ->
    @trigger 'validation:error'
    @clearErrors()
    @model.validationError?.forEach? (attribute) =>
      @_fieldFor(attribute).addClass(ERROR_STATE_CLASS_NAME)

  clearErrors: ->
    @_getFormFields().forEach ($field) ->
      $field.removeClass(ERROR_STATE_CLASS_NAME)

  updateModel: ->
    @model.deserialize
      name: @ui.name.val()
      birthday: @ui.birthday.val()
      email: @ui.email.val()
      siteUrl: @ui.siteUrl.val()
      phone: @ui.phone.val()
      skill: @ui.skill.val()
      password: @ui.password.val()
      confirm: @ui.confirm.val()
      about: @ui.about.val()
    @model.validateChanged()

  updateView: ->
    Object.keys(@model.changed).forEach (key) =>
      @_updateField key, @model.get(key)

  _updateField: (fieldName, fieldValue) ->
    switch fieldName
      when 'gender' then @_switchGenderField()
      else @ui[fieldName]?.val? fieldValue

  _switchGenderField: ->
    @ui.genderMale.add(@ui.genderFemale).removeClass SELECTED_GENDER_CLASS_NAME
    switch true
      when @model.isMale() then @ui.genderMale.addClass SELECTED_GENDER_CLASS_NAME
      when @model.isFemale() then @ui.genderFemale.addClass SELECTED_GENDER_CLASS_NAME

  _fieldFor: (attribute) ->
    switch attribute
      when 'gender'
        @ui.genderMale.closest(".#{FIELD_CLASS_NAME}").add(@ui.genderFemale.closest(".#{FIELD_CLASS_NAME}"))
      else
        @ui[attribute]?.closest(".#{FIELD_CLASS_NAME}")

  _getFormFields: ->
    ['name', 'birthday', 'email', 'siteUrl', 'phone', 'skill', 'about', 'gender', 'password', 'confirm'].map (attribute) =>
      @_fieldFor(attribute)

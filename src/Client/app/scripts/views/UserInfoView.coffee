Marionette = require 'backbone.marionette'

module.exports = Marionette.ItemView.extend
  template: false

  ui:
    name: '.js-user-name'
    birthday: '.js-user-birthday'
    email: '.js-user-email'
    siteUrl: '.js-user-site'
    phone: '.js-user-phone'
    skill: '.js-user-skill'
    gender: '.js-user-gender'
    about: '.js-user-about'

  modelEvents:
    change: 'updateView'

  onRender: ->
    @updateModel();

  updateModel: ->
    @model.deserialize @_extractViewData()

  updateView: ->
    Object.keys(@model.changed).forEach (key) =>
      @_updateField key, @model.get(key)

  _updateField: (fieldName, fieldValue) ->
    switch fieldName
      when 'gender' then fieldValue = @model.getGenderTitle()
      when 'birthday' then fieldValue = @model.getBirthdayTitle()
    @ui[fieldName]?.text? fieldValue

  _extractViewData: ->
    data = {}
    Object.keys(@ui).forEach (key) =>
      data[key] = @_extractField(key)
    return data

  _extractField: (fieldName) ->
    $.trim(@ui[fieldName]?.text?() or @ui[fieldName]?.val?())

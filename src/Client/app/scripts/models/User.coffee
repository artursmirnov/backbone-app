Backbone = require 'backbone'
_ = require 'underscore'

MIN_DATE = new Date '1950-01-01'
MAX_DATE = Date.now()

User = Backbone.Model.extend

  defaults:
    name: ''
    birthday: null
    email: ''
    siteUrl: ''
    phone: ''
    skill: null
    gender: null
    password: ''
    confirm: ''
    about: ''

  validators:
    name: -> _.isString(@) and not _.isEmpty(@)
    birthday: -> MAX_DATE > new Date(@) > MIN_DATE or _.isEmpty(@)
    email: -> _.isString(@) and @match(/\w+@\w+\.\w+/)
    phone: -> _.isString(@) and @match(/\+\d{11}/) or _.isEmpty(@)
    skill: -> $.isNumeric(@) or _.isEmpty(@)
    gender: -> @toString() is User.GENDER.MALE or @toString() is User.GENDER.FEMALE or _.isEmpty(@)
    password: -> not _.isEmpty(@)
    confirm: -> not _.isEmpty(@)

  deserialize: (data = {}) ->
    if data instanceof Backbone.Model then data = data.toJSON()
    @_extractGender data
    @set(data)

  isMale: ->
    @get('gender') is User.GENDER.MALE

  isFemale: ->
    @get('gender') is User.GENDER.FEMALE

  setMale: ->
    @set 'gender', User.GENDER.MALE

  setFemale: ->
    @set 'gender', User.GENDER.FEMALE

  validate: (attributes) ->
    errors = []
    Object.keys(attributes).forEach (key) =>
      value = attributes[key]
      validator = @validators[key]
      if typeof validator is 'function' and not validator.apply(value) then errors.push key
    if attributes.password is not attributes.confirm then errors.push 'confirm'
    if errors.length then return errors

  _extractGender: (data) ->
    switch data.gender?.toLowerCase()
      when User.GENDER.MALE then @setMale()
      when User.GENDER.FEMALE then @setFemale()
    delete data.gender


User.GENDER =
  MALE: 'male'
  FEMALE: 'female'

module.exports = User

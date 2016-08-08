Backbone = require 'backbone'
_ = require 'underscore'

MIN_DATE = new Date '1950-01-01'
MAX_DATE = Date.now()

User = Backbone.Model.extend

  defaults:
    _token: ''
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

  serialize: ->
    gender = switch @get('gender')
      when User.GENDER.MALE then 0
      when User.GENDER.FEMALE then 1

    birthday = @get('birthday')?.split('-') or []

    result =
      user:
        _token: @get '_token'
        userName: @get 'name'
        userEmail: @get 'email'
        siteUrl: @get 'siteUrl'
        userBirthday:
          month: parseInt(birthday[1])
          day: parseInt(birthday[2])
          year: parseInt(birthday[0])
        userGender: gender
        userPhone: @get 'phone'
        userSkill: @get 'skill'
        userAbout: @get 'about'
        password:
          first: @get 'password'
          second: @get 'confirm'
    return result

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

  parse: (response, options) ->
    name: response['[userName]']?.value
    birthday: "#{response['[userBirthday][year]']?.value}-#{response['[userBirthday][month]']?.value}-#{response['[userBirthday][day]']?.value}"
    email: response['[userEmail]']?.value
    siteUrl: response['[siteUrl]']?.value
    phone: response['[userPhone]']?.value
    skill: response['[userSkill]']?.value
    gender: response['[userGender]']?.value_label
    about: response['[userAbout]']?.value

  sync: (method, model, options) ->
    options.attrs = @serialize()
    Backbone.Model.prototype.sync.call(@, method, model, options)

  _extractGender: (data) ->
    switch data.gender?.toLowerCase()
      when User.GENDER.MALE then @setMale()
      when User.GENDER.FEMALE then @setFemale()
    delete data.gender


User.GENDER =
  MALE: 'male'
  FEMALE: 'female'

module.exports = User

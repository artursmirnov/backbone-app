Backbone = require 'backbone'
moment = require 'moment'
_ = require 'underscore'

MIN_DATE = new Date '1900-01-01'
MAX_DATE = Date.now()
DEFAULT_MOMENT_BIRTHDAY_FORMAT = 'DD MMMM YYYY'

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
    birthday: -> MAX_DATE > @ > MIN_DATE or @ instanceof Date isnt true and _.isEmpty(@)
    email: -> _.isString(@) and /^.+@.+\..+$/.test(@)
    phone: -> _.isString(@) and /^\+\d{11}$/.test(@) or _.isEmpty(@)
    siteUrl: -> _.isString(@) and /.+\..+/.test(@) or _.isEmpty(@)
    skill: -> $.isNumeric(@) and @ >= 0 or _.isEmpty(@)
    gender: -> parseInt(@) is User.GENDER.MALE or parseInt(@) is User.GENDER.FEMALE or _.isEmpty(@)
    password: -> not _.isEmpty(@)
    confirm: -> not _.isEmpty(@)

  validationError: []

  initialize: ->
    this.bind 'error', => @_handleRequestError.apply(@, arguments)

  deserialize: (data = {}) ->
    if data instanceof Backbone.Model then data = data.toJSON()
    if data.gender then data.gender = @_normalizeGender(data.gender)
    if data.birthday then data.birthday = @_parseBirthday(data.birthday)
    @set(data)

  serialize: ->
    birthday = @get('birthday') or null
    user:
      _token: @get '_token'
      userName: @get 'name'
      userEmail: @get 'email'
      siteUrl: @get 'siteUrl'
      userBirthday:
        year: birthday?.getFullYear()
        month: birthday?.getMonth() + 1
        day: birthday?.getDate()
      userGender: @get 'gender'
      userPhone: @get 'phone'
      userSkill: @get 'skill'
      userAbout: @get 'about'
      password:
        first: @get 'password'
        second: @get 'confirm'

  isMale: ->
    @get('gender') is User.GENDER.MALE

  isFemale: ->
    @get('gender') is User.GENDER.FEMALE

  setMale: ->
    @set 'gender', User.GENDER.MALE

  setFemale: ->
    @set 'gender', User.GENDER.FEMALE

  getGenderTitle: ->
    switch true
      when @isMale() then 'Male'
      when @isFemale() then 'Female'
      else ''

  getBirthdayTitle: (format = DEFAULT_MOMENT_BIRTHDAY_FORMAT) ->
    birthday = @get 'birthday'
    if birthday then moment(birthday).format(format) else ''

  validate: (attributes) ->
    errors = []
    Object.keys(attributes).forEach (key) =>
      value = attributes[key]
      validator = @validators[key]
      if typeof validator is 'function' and not validator.apply(value or {}) then errors.push key
    if attributes.password isnt attributes.confirm then errors.push 'confirm'
    if errors.length then return errors

  validateChanged: ->
    changed = _.clone(@changed) or {}
    if changed.password and not changed.confirm then changed.confirm = @get 'confirm'
    if changed.confirm and not changed.password then changed.password = @get 'password'
    @validationError = _.difference @validationError, Object.keys(changed)
    @validationError = _.union @validationError, @validate(changed)
    @trigger if @validationError.length is 0 then 'valid' else 'invalid'

  parse: (response, options) ->
    name: response['[userName]']?.value
    birthday: @_parseBirthday("#{response['[userBirthday][year]']?.value}-#{response['[userBirthday][month]']?.value}-#{response['[userBirthday][day]']?.value}")
    email: response['[userEmail]']?.value
    siteUrl: response['[siteUrl]']?.value
    phone: response['[userPhone]']?.value
    skill: response['[userSkill]']?.value
    gender: response['[userGender]']?.value
    about: response['[userAbout]']?.value

  sync: (method, model, options) ->
    options.attrs = @serialize()
    Backbone.Model.prototype.sync.call(@, method, model, options)

  _normalizeGender: (gender) ->
    switch true
      when parseInt(gender) is User.GENDER.MALE then User.GENDER.MALE
      when parseInt(gender) is User.GENDER.FEMALE then User.GENDER.FEMALE
      when _.isString(gender) and gender.toLowerCase() is 'male' then User.GENDER.MALE
      when _.isString(gender) and gender.toLowerCase() is 'female' then User.GENDER.FEMALE
      else null

  _parseBirthday: (date) ->
    switch true
      when not isNaN(Date.parse(date))
        new Date(Date.parse(date) - new Date().getTimezoneOffset() * 60000)
      when moment(date, DEFAULT_MOMENT_BIRTHDAY_FORMAT).isValid()
        moment(date, DEFAULT_MOMENT_BIRTHDAY_FORMAT).utc().toDate()
      else null

  _handleRequestError: (model, response, options) ->
    responseBody = response?.responseJSON?.errors?.children or {}
    errors = []
    for field, content of responseBody
      if content?.errors?.length > 0
        errors.push if field is 'siteUrl' then field else field.replace('user', '').toLowerCase()
    @validationError = errors
    @trigger 'invalid'


User.GENDER =
  MALE: 0
  FEMALE: 1

module.exports = User

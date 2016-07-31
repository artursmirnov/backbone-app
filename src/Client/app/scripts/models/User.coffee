Backbone = require 'backbone'

User = Backbone.Model.extend

  defaults:
    name: ''
    birthday: null
    email: ''
    siteUrl: ''
    phone: ''
    skill: null
    gender: null
    about: ''

  deserialize: (data) ->
    data = data || {}
    @set(data)

  isMale: ->
    @get('gender') is User.GENDER.MALE

  isFemale: ->
    @get('gender') is User.GENDER.FEMALE

  setMale: ->
    @set 'gender', User.GENDER.MALE

  setFemale: ->
    @set 'gender', User.GENDER.FEMALE

User.GENDER =
  MALE: 'male'
  FEMALE: 'female'

module.exports = User

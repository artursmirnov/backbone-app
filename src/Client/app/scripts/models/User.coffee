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

  _extractGender: (data) ->
    switch data.gender?.toLowerCase()
      when User.GENDER.MALE then @setMale()
      when User.GENDER.FEMALE then @setFemale()
    delete data.gender

User.GENDER =
  MALE: 'male'
  FEMALE: 'female'

module.exports = User

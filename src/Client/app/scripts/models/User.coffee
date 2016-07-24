Backbone = require 'backbone'

module.exports = Backbone.Model.extend

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

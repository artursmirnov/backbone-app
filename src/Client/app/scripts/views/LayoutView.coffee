Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

User = require 'models/User'

HeaderView = require 'views/HeaderView'
UserInfoView = require 'views/UserInfoView'
EditFormView = require 'views/EditFormView'

ModalView = require 'views/ModalView'
ModalRegion = require 'regions/ModalRegion'

SELECTORS =
  APP: '#app'
  HEADER: '#header'
  USER_INFO: '#user-info'

module.exports = Marionette.LayoutView.extend
  template: false
  el: SELECTORS.APP

  regions:
    header: SELECTORS.HEADER
    userInfo: SELECTORS.USER_INFO
    modal:
      regionClass: ModalRegion


  initialize: ->
    @user = new User

  onBeforeRender: ->
    @_attachHeaderView()
    @_attachUserInfoView()

  onShowUserInfo: ->
    @getRegion('modal').empty()

  onShowEditForm: ->
    editView = new EditFormView model: @user

    modalView = new ModalView bodyView: editView

    modalView.on 'action:primary', ->
      console.log('primary action')

    modalView.on 'close', ->
      Backbone.history.navigate '', trigger: true

    @getRegion('modal').show modalView

  _attachHeaderView: ->
    headerView = new HeaderView el: SELECTORS.HEADER
    @getRegion('header').attachView headerView
    headerView.render()

  _attachUserInfoView: ->
    userInfoView = new UserInfoView el: SELECTORS.USER_INFO, model: @user
    @getRegion('userInfo').attachView userInfoView
    userInfoView.render()

Marionette = require 'backbone.marionette'

User = require 'models/User'

HeaderView = require 'views/HeaderView'
UserInfoView = require 'views/UserInfoView'
EditFormView = require 'views/EditFormView'

ModalView = require 'views/ModalView'

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
      el: $('<div/>').appendTo('body')


  initialize: ->
    @user = new User

  onBeforeRender: ->
    @_attachHeaderView()
    @_attachUserInfoView()

  onShowUserInfo: ->
    console.log 'user info'
    @getRegion('modal').empty()

  onShowEditForm: ->
    console.log 'show edit form'
    editView = new EditFormView model: @user
    modalView = new ModalView bodyView: editView
    @getRegion('modal').show modalView

  _attachHeaderView: ->
    headerView = new HeaderView el: SELECTORS.HEADER
    @getRegion('header').attachView headerView
    headerView.render()

  _attachUserInfoView: ->
    userInfoView = new UserInfoView el: SELECTORS.USER_INFO, model: @user
    @getRegion('userInfo').attachView userInfoView
    userInfoView.render()

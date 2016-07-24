Marionette = require 'backbone.marionette'

User = require 'models/User'

HeaderView = require 'views/HeaderView'
UserInfoView = require 'views/UserInfoView'

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


  initialize: ->
    @user = new User

  onBeforeRender: ->
    @_attachHeaderView()
    @_attachUserInfoView()

  onShowUserInfo: ->
    console.log 'user info'

  onShowEditForm: ->
    console.log 'edit user'

  _attachHeaderView: ->
    headerView = new HeaderView el: SELECTORS.HEADER, model: @user
    @getRegion('header').attachView headerView
    headerView.render()

  _attachUserInfoView: ->
    userInfoView = new UserInfoView el: SELECTORS.USER_INFO, model: @user
    @getRegion('userInfo').attachView userInfoView
    userInfoView.render()

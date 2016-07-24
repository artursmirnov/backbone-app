Marionette = require 'backbone.marionette'

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

    header:
      el: SELECTORS.HEADER
      currentView: new HeaderView el: SELECTORS.HEADER

    userInfo:
      el: SELECTORS.USER_INFO
      currentView: new UserInfoView el: SELECTORS.USER_INFO


  onShowUserInfo: ->
    console.log 'user info'

  onShowEditForm: ->
    console.log 'edit user'
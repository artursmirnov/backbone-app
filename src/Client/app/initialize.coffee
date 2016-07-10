window.$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

App = require 'components/App'

window.__agent?.start Backbone, Marionette

document.addEventListener 'DOMContentLoaded', =>
  app = new App()
  app.start()

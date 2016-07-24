window.$ = require 'jquery'

App = require 'App'

$(document).ready ->
  app = new App
  app.start()

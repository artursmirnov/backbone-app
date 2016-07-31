window.$ = require 'jquery'

App = require 'App'

$(document).ready ->
  # necessary for css input[value=] selectors to work
  $(document).on 'input keyup change', 'input, textarea', -> @setAttribute 'value', @value

  app = new App
  app.start()

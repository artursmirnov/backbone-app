Marionette = require 'backbone.marionette'

module.exports = Marionette.Region.extend
  el: '#modal-outlet'

  attachHtml: (view) ->
    @$el.empty().append(view.el)

  onShow: ->
    setTimeout =>
      @$el.addClass('opened')
    , 0

  show: (view, options) ->
    options = options || {}
    options.preventDestroy = true
    Marionette.Region.prototype.show.call @, view, options

  empty: (options) ->
    @$el.removeClass('opened')
    setTimeout =>
      Marionette.Region.prototype.empty.call @, options
    , 500

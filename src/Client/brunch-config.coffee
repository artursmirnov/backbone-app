# See http://brunch.io for documentation.

module.exports =

  paths:
    public: '../../web/bundles/app'

  files:

    javascripts:
      joinTo:
        'app.js': /^app/
        'vendor.js': /^(?!app)/

    stylesheets:
      joinTo: 'app.css'

    templates:
      joinTo: 'app.js'

  modules:
    nameCleaner: (path) -> path.replace 'app/scripts/', ''

  plugins:

    sass:
      allowCache: true
      sourceMapEmbed: true

    postcss:
      processors: [
        require('autoprefixer')(['ie >= 9', 'last 3 versions']) # https://github.com/ai/browserslist#queries
      ]

    coffeelint:
      options: {}
        # http://www.coffeelint.org/#options

    copycat:
      fonts: ['node_modules/material-design-icons/iconfont']
      verbose: true
      onlyChanged: true

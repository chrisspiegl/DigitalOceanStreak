###
|--------------------------------------------------------------------------
| Gruntfile.coffee
|--------------------------------------------------------------------------
|
|
|
###
module.exports = (grunt) ->

  ###
  |--------------------------------------------------------------------------
  | Project configuration.
  |--------------------------------------------------------------------------
  ###
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    paths:
      executable: 'index'
      devExecutable: 'lib-coffee/index.coffee'
      tests: 'test'
      lib: 'lib-coffee'
      public: 'public'
      assets: 'assets'

    ###
    |--------------------------------------------------------------------------
    | Clean
    |--------------------------------------------------------------------------
    ###
    clean:
      css: [
        '<%= paths.public %>/css/*'
      ]
      # js: [
      #   '<%= paths.public %>/js/*'
      # ]
      # fonts: [
      #   '<%= paths.public %>/fonts/*'
      # ]
      # images: [
      #   '<%= paths.public %>/images/*'
      # ]

    ###
    |--------------------------------------------------------------------------
    | Copy
    |--------------------------------------------------------------------------
    ###
    # copy:
    #   fonts:
    #     files: [
    #       { # includes files in path and its subdirs
    #         expand: true
    #         cwd: '<%= paths.assets %>/fonts/'
    #         src: '**'
    #         dest: '<%= paths.public %>/fonts'
    #       }
    #     ]
    #   images:
    #     files: [
    #       { # includes files in path and its subdirs
    #         expand: true
    #         cwd: '<%= paths.assets %>/images/'
    #         src: '**'
    #         dest: '<%= paths.public %>/images/'
    #       }
    #     ]

    ###
    |--------------------------------------------------------------------------
    | Compass
    |--------------------------------------------------------------------------
    ###
    compass:
      dist:
        options:
          sassDir: '<%= paths.assets %>/sass'
          cssDir: '<%= paths.public %>/css'
          environment: 'production'
      dev:
        options:
          sassDir: '<%= paths.assets %>/sass'
          cssDir: '<%= paths.public %>/css'


    ###
    |--------------------------------------------------------------------------
    | Nodemon - autoreload app
    |--------------------------------------------------------------------------
    ###
    nodemon:
      dev:
        options:
          nodeArgs: [] # '--debug'
          file: '<%= paths.devExecutable %>'
          env:
            _DEV: true
          ignoredFiles: ['README.md', 'node_modules/**', 'assets/**']
          watchedFolders: ['<%= paths.lib %>']

    ###
    |--------------------------------------------------------------------------
    | Concurrent - do things in parallel
    |--------------------------------------------------------------------------
    ###
    concurrent:
      default:
        tasks: [
          'nodemon'
          'watch:livereload'
          'watch:frontEndSass'
          # 'watch:frontEndFonts'
          # 'watch:frontEndImages'
        ]
        options:
          logConcurrentOutput: true

    ###
    |--------------------------------------------------------------------------
    | Watch - watch for changes and reload or do stuff
    |--------------------------------------------------------------------------
    ###
    watch:
      livereload:
        files: [
          'tmp/livereload'
          '<%= paths.public %>/**/*'
        ]
        options:
          livereload: true
        tasks: []
      frontEndSass:
        files: ['<%= paths.assets %>/sass/**/*']
        tasks: ['compass:dev']
      # frontEndFonts:
      #   files: ['<%= paths.assets %>/fonts/**/*']
      #   tasks: ['clean:fonts', 'copy:fonts']
      # frontEndImages:
      #   files: ['<%= paths.assets %>/images/**/*']
      #   tasks: ['clean:images', 'copy:images']

  ###
  |--------------------------------------------------------------------------
  | loadNpmTasks
  |--------------------------------------------------------------------------
  ###
  require('matchdep').filterDev('grunt-*').forEach(@loadNpmTasks)

  ###
  |--------------------------------------------------------------------------
  | registerTasks
  |--------------------------------------------------------------------------
  ###
  @registerTask 'default', ['setupDev', 'concurrent:default']

  @registerTask 'setupDev', ['clean', 'compass:dev']

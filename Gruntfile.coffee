module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-chmod'

  grunt.initConfig
    meta:
      shebang: '#!/usr/bin/env node'
      hacking: """
        // Please don't edit this file directly. It is compiled from the CoffeeScript
        // in summon.coffee. If you edit the CoffeeScript source and compile its changes,
        // please keep the commits to this file separate. See the README for instructions
        // on setting up a pre-commit hook to help with that.
      """

    coffee:
      default:
        options:
          bare: true
        files:
          'summon': 'summon.coffee'

    # Prepend the node shebang line
    concat:
      options:
        banner: '<%= meta.shebang %>\n\n<%= meta.hacking %>\n\n'
      dist:
        src: 'summon'
        dest: 'summon'

    # Make sure the file is executable
    chmod:
      options:
        mode: '755'
      target:
        src: 'summon'

  grunt.registerTask 'default', ['coffee', 'concat', 'chmod']

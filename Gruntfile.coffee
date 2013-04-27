module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-chmod'

  grunt.initConfig
    meta:
      shebang: '#!/usr/bin/env node'

    coffee:
      default:
        options:
          bare: true
        files:
          'summon': 'summon.coffee'

    # Prepend the node shebang line
    concat:
      options:
        banner: '<%= meta.shebang %>\n'
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

module.exports = (grunt)->

    coffeeify = require "coffeeify"
    stringify = require "stringify"
    fs = require "fs"

    grunt.initConfig
        connect:
            server:
                options:
                    port: 3000
                    base: "."

        clean: 
            bin: ["bin"]
            dist: ["dist"]

        copy:
            assets:
                src: "assets/**/*"
                dest: "dist/"
            lib:
                src: "lib/**/*"
                dest: "dist/"

        browserify: 
            dev: 
                options:
                    preBundleCB: (b)->
                        b.transform(coffeeify)
                        b.transform(stringify({extensions: [".hbs", ".html", ".tpl", ".txt"]}))
                expand: true
                flatten: true
                src: ["src/coffee/main.coffee"]
                dest: "bin/js"
                ext: ".js"
            test:
                options:
                    preBundleCB: (b)->
                        b.transform(coffeeify)
                        b.transform(stringify({extensions: [".hbs", ".html", ".tpl", ".txt"]}))
                expand: true
                flatten: true
                src: ["test/test.coffee"]
                dest: "bin/test"
                ext: ".js"

        watch:
            compile:
                options:
                    livereload: true
                files: [
                    "src/**/*.coffee", 
                    "src/**/*.less", 
                    "src/**/*.html", 
                    "index.html",
                    "about.html",
                    "test/**/*.coffee", 
                    "test/**/*.html"
                ]
                tasks: ["browserify", "less"]

        less:    
            dev:
                files:
                    "bin/css/index.css": ["src/less/index.less"],
                    "bin/css/common.css": ["src/less/common.less"]


        uglify:
            build:
                files: [{
                  expand: true
                  cwd: "bin/js/"
                  src: ["**/*.js"]
                  dest: "dist/js"
                  ext: ".js"
                }]

        cssmin:    
            build:
                files:
                    "dist/css/index.css": ["bin/css/index.css"],
                    "dist/css/common.css": ["bin/css/common.css"]

        mocha:
            test:
                src: ["test/**/*.html"]
                options:
                    run: true
                    reporter: "Spec"

    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-browserify"
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-cssmin"
    grunt.loadNpmTasks "grunt-contrib-copy"

    grunt.registerTask "default", ->
        grunt.task.run [
          "connect"
          "clean:bin"
          "browserify"
          "less"
          "watch"
          "copy"
        ]

    grunt.registerTask "index", ->
        index = fs.readFileSync "index.html", "utf-8"
        index = index.replace /bin\//g, ""
        index = index.replace "<script src=\"//localhost:35729/livereload.js\"></script>", ""
        fs.writeFileSync "dist/index.html", index

    grunt.registerTask "about", ->
        about = fs.readFileSync "about.html", "utf-8"
        about = about.replace /bin\//g, ""
        about = about.replace "<script src=\"//localhost:35729/livereload.js\"></script>", ""
        fs.writeFileSync "dist/about.html", about

    grunt.registerTask "bsy", ->
        bsy = fs.readFileSync "bsy.html", "utf-8"
        bsy = bsy.replace /bin\//g, ""
        bsy = bsy.replace "<script src=\"//localhost:35729/livereload.js\"></script>", ""
        fs.writeFileSync "dist/bsy.html", bsy

    grunt.registerTask "rongwan", ->
        rongwan = fs.readFileSync "rongwan.html", "utf-8"
        rongwan = rongwan.replace /bin\//g, ""
        rongwan = rongwan.replace "<script src=\"//localhost:35729/livereload.js\"></script>", ""
        fs.writeFileSync "dist/rongwan.html", rongwan

    grunt.registerTask "build", ->
        grunt.task.run [
            "clean:bin"
            "clean:dist"
            "browserify" 
            "less" 
            "uglify"
            "cssmin"
            # "copy"
            "index"
            "about"
            "bsy"
            "rongwan"
        ]

fs            = require 'fs'
{exec, spawn} = require 'child_process'

try
  which = require('which').sync
catch err
  if process.platform.match(/^win/)?
    console.log 'WARNING: the which module is required for windows\ntry: npm install which'
  which = null

# order of files in `inFiles` is important
config =
  srcDir:  'src'
  outDir:  'lib'
  inFiles: [
    'Namespace'
    'core/Controller'
    'core/Model'
    'core/View'
    'patterns/facade/Facade'
    'patterns/observer/Notifier'
    'patterns/observer/Notification'
    'patterns/observer/Observer'
    'patterns/command/MacroCommand'
    'patterns/command/SimpleCommand'
    'patterns/mediator/Mediator'
    'patterns/proxy/Proxy'
  ]
  outFile: "puremvc-1.0"

outJS = "#{config.outDir}/#{config.outFile}"
files = ("#{config.srcDir}/#{file}.coffee" for file in config.inFiles)

# tasks
task 'build', 'compile source', -> build -> min -> log 'build done', green

task 'watch', 'compile and watch', -> build true, -> log ":-)", green

task 'test', 'run tests', -> build -> mocha -> log ":)", green


# ANSI Terminal Colors
bold = '\x1b[0;1m'
green = '\x1b[0;32m'
reset = '\x1b[0m'
red = '\x1b[0;31m'

# Write log message
log = (message, color, explanation) -> console.log color + message + reset + ' ' + (explanation or '')

# Launch external command
launch = (cmd, options=[], callback) ->
  cmd = which(cmd) if which
  app = spawn cmd, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) -> callback?() if status is 0

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false

  options = ['-c', '-j', "#{outJS}.js"]
  options = options.concat files
  options.unshift '-w' if watch
  launch 'coffee', options, callback

min = (callback) ->
  options = ['-o', "#{outJS}.min.js", "#{outJS}.js"]
  launch 'uglifyjs', options, callback

mocha = (options, callback) ->
  #if moduleExists('mocha')
  if typeof options is 'function'
    callback = options
    options = []
  # add coffee directive
  options.push '--compilers'
  options.push 'coffee:coffee-script'

  launch 'mocha', options, callback

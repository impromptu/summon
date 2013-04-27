# Get some Node magic
exec     = require('child_process').exec
readline = require 'readline'
async    = require 'async'

# We're going to ask the user some questions
userInput = readline.createInterface
  input  : process.stdin
  output : process.stdout

# Make sure you gave us a package to install, otherwise exit with an error
if process.argv.length < 3
  console.log 'Pass the package name you want to install as the first argument.'
  console.log 'Usage: ./install [packageName]'
  console.log 'Example: ./install git'
  process.exit 1

# This is the thing we want to install
packageName = process.argv[2]

# Check to see if the package is already installed
exec("command -v #{packageName}").on 'exit', (code) ->
  # You already have the package installed, good job
  process.exit 0 if code is 0

  # The dependency isn't installed
  # Alert the user and kick of the process of trying to install it
  console.log "You are missing #{packageName}, which is a required dependency."
  tryToInstall()


tryToInstall = ->
  # Let people decide whether to try the automatic install
  # Defaults to yes
  userInput.question "Do you want to try to install #{packageName} automatically? (Y/n) ", (answer) ->
    # If the user doesn't want to try to install the package automatically, let them
    # know they'll need to do it themselves and exit with an error code.
    if /^n/i.test answer
      console.log "\nPlease install #{packageName} and then re-run this installer."
      process.exit 1

    # Start looking for package managers
    console.log "Okay, let's try to install #{packageName}.\n"
    installers = getPlatformInstallers()

    # Make sure a package manager exists before we try to use it
    async.filter installers, (installer, callback) ->
      exec("command -v #{installer}").on 'exit', (code) ->
        callback code is 0

    , (installers) ->
      # If we couldn't find a package manager, let the user do it themselves
      if installers.length is 0
        console.log "We couldn't find any package managers."
        console.log "Please install #{packageName}and then re-run this installer."
        process.exit 1

      # Show a list of package managers that should be availabe
      console.log "We looked for package mangers and found:"
      console.log "#{key + 1}) #{installer}" for installer, key in installers

      # Give the user a choice of which one to use
      # Defaults to the first
      userInput.question "\nDo you want to use one of these? Or let us know what command you prefer. (1/#/[command]) ", (choice) ->
        if /^\d+$/.test choice
          installer = installers[choice - 1]
        else if choice
          installer = choice
        else
          installer = installers[0]
          console.log "Using the default installer: #{installer}"

        # Make sure you chose something valid (even if it was a blank/default choice)
        unless installer
          console.log '\nOops, not a valid choice.'
          process.exit 1

        # Build and run the command
        runInstallCommand packageName

runInstallCommand = (command) ->
  command = "#{installer} install #{packageName}"

  # Let the user know what we're about to do
  console.log "\nOkay, going to try running: #{command}\n"

  # Give them one last chance to bail
  userInput.question 'Good to go? (Y/n) ', (answer) ->
    if answer and /^n/i.test answer
      console.log "\nOkay, we won't do it. You're on your own for installing #{packageName}."
      process.exit 0

    # Time to do this thing. Run the install command
    exec(command).on 'exit', (code) ->
      # If it worked, tell the user
      if code is 0
        console.log '\nAwesome, that worked! Enjoy!'
        process.exit 0

      # If it failed, let the user know and exit with an error code
      else
        console.log "\nUh oh, looks like that didn't work."
        console.log "Please install #{packageName} and then re-run this installer."
        process.exit 1

# Try to make some reasonable guesses at what package managers might be available
# We'll check that each is installed before offering it
getPlatformInstallers = ->
  if process.platform is "linux" and process.arch is "x64"
    ["apt-get", "yum"]
  else if process.platform is "darwin"
    ["brew", "port", "fink"]
  else if process.platform is "win32"
    # Seems like at least some people like this one
    # http://stackoverflow.com/questions/9751845/apt-get-for-cygwin
    ["apt-cyg"]
  else
    []

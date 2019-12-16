# README

Welcome to Rover HQ

## Demo

* If you don't feel like going through any of this setup business and just want to see the app in action, just go to https://rover-hq.herokuapp.com/ and start exploring!

## Versions

* This app is built on Rails 6 and Ruby 2.6.3.

## Setup

* Clone the repo https://github.com/bryandotnewton/rover-hq.git
* Install Postgresql if not already installed
  * The easiest way on a Mac is via homebrew with `brew install postgresql`
  * If homebrew is not yet installed, it can be done so by following the directions here: https://docs.brew.sh/Installation
  * If a different OS is being used, find installation instructions here: http://postgresguide.com/setup/install.html
* Start the database service with `brew services start postgresql`
* Create the database with `rake db:create`
* Migrate the database with `rake db:migrate`

## Start up

* The best way to start the app is to install the Foreman gem with `gem install foreman` and run `foreman start -f Procfile.dev` from the app root directory
* Alternately, you can simply run `rails s` in the app root directory

## Tests

* The test suite is written with Minitest and can be run with `rake test` or `rails test`

## Input files

* There are 4 test input files in the /public directory:
  * default-command-sheet.txt - command sheet specified in the project documentation
  * collision-command-sheet.txt - command sheet which causes a rover collision
  * out-of-bounds-command-sheet.txt - command sheet which causes a rover to fall off the plateau
  * too-many-rovers-command-sheet.txt - command sheet which specifies more rovers than we have available

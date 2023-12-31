# Terraform Beginner Bootcamp 2023 - Week 2

## Working with Ruby

### Bundler

Bundler is a package manager for Ruby.
It is the primary way to install Ruby 
packages (known as gems) for Ruby.

#### Installing Gems

You need to create a Gemfile and define your gems
in that file. 

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```
Then you need to install the `bundle run` command.\

This will install the gems on the system globally (unlike
node.js which installs packages in place in a folder
called node_modules)

A Gemfile.lock file will be created to lock down the
gem versions being used in this project.

#### Executing Ruby scripts in the context of bundler.

We have to use `bundle.exe` to tell future ruby scripts to
use the gems we installed. This is the way we set context. 


### Sinatra

Sinatra is micro web-framwork for Ruby to build web-apps.

It's great for mock or developer servers or for very simple projects.  

You can create a web-server in a single file.

https://sinatrarb.com

## Terratowns Mock Server


### Running the web server.

We can run the web server by executing th following commands:

```rb
bundle install
bundle exec server.rb
```

All of the code for our server is stored in the `server.rb` file.
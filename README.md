# Giddy 
[![Build Status](https://travis-ci.org/andela-tfowotade/giddy.svg?branch=giddy-orm)](https://travis-ci.org/andela-tfowotade/giddy) [![Coverage Status](https://coveralls.io/repos/github/andela-tfowotade/hana/badge.svg)](https://coveralls.io/github/andela-tfowotade/hana) [![Code Climate](https://codeclimate.com/repos/57ed08d88867c9138a001ab1/badges/720196928a0121fa0bef/gpa.svg)](https://codeclimate.com/repos/57ed08d88867c9138a001ab1/feed)

Hana is an mvc framework built with Ruby for building web applications. It is a lightweight portable ruby web framework modelled after Rails. Hana is ligthweight and hence fit for simple and quick applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hana'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hana

## Usage

When creating a new Hana app, a few things need to be setup and a few rules adhered to. Hana basically follows the same folder structure as a typical rails app with all of the model, view and controller code packed inside of an app folder, configuration based code placed inside a config folder and the main database file in a db folder.

View a sample app built using Hana framework [Here](https://github.com/andela-tfowotade/hana/tree/develop/spec/todo)


## Key Features

### Routing
Routing with Hana deals with directing requests to the appropriate controllers. A sample route file is:

```ruby
TodoApplication.routes.draw do
  get "/todo", to: "todo#index"
  get "/todo/new", to: "todo#new"
  post "/todo", to: "todo#create"
  get "/todo/:id", to: "todo#show"
  get "/todo/:id/edit", to: "todo#edit"
  patch "/todo/:id", to: "todo#update"
  put "/todo/:id", to: "todo#update"
  delete "/todo/:id", to: "todo#destroy"
end

```
Hana supports GET, DELETE, PATCH, POST, PUT requests.


### Models
All models to be used with the Hana framework are to inherit from the BaseModel class provided by Hana, in order to access the rich ORM functionalities provided. The BaseModel class acts as an interface between the model class and its database representation. A sample model file is provided below:

```ruby
class User < Hana::BaseModel
  to_table :users
  property :id, type: :integer, primary_key: true
  property :name, type: :text, nullable: false
  property :age, type: :integer, nullable: false
  property :interests, type: :text, nullable: false
  create_table
end
```
The `to_table` method provided stores the table name used while creating the table record in the database.

The `property` method is provided to declare table columns, and their properties. The first argument `property` is the column name, while subsequent hash arguments are used to provide information about properties.

The `type` argument represents the data type of the column. Supported data types by Hana are:

  * integer (for numeric values)
  * boolean (for boolean values [true or false])
  * text    (for alphanumeric values)

The `primary_key` argument is used to specify that the column should be used as the primary key of the table. If this is an integer, the value is auto-incremented by the database.

The `nullable` argument is used to specify whether a column should have null values, or not.


On passing in the table name, and its properties, a call should be made to the `create_table` method to persist the model to database by creating the table.


### Controllers
Controllers are key to the MVC structure, as they handle receiving requests, interacting with the database, and providing responses. Controllers are placed in the controllers folder, which is nested in the app folder.

All controllers should inherit from the BaseController class provided by Hana to inherit methods which simplify accessing request parameters and returning responses by rendering views.

A sample structure for a controller file is:

```ruby
class TodoController < Hana::ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def show
    user = User.find(params[:id])
  end

  def destroy
    user.destroy
  end
end
```

Instance variables set by the controllers are passed to the routes while rendering responses.

Explicitly calling `render` to render template files is optional. If it's not called by the controller action, then it's done automatically by the framework with an argument that's the same name as the action.


### Views
Currently, view templates are handled through the Tilt gem. See https://github.com/rtomayko/tilt for more details.

View templates are mapped to controller actions and must assume the same nomenclature as their respective actions. Views are placed inside the `app/views` folder. A view to be rendered for the new action in the UserController for example is saved as `new.html.erb` in the user folder, nested in the views folder.

### External Dependencies
The Hana framework has a few dependencies. These are listed below, with links to source pages for each.

  * sqlite3     - https://github.com/sparklemotion/sqlite3-ruby
  * bundler     - https://github.com/bundler/bundler
  * rake        - https://github.com/ruby/rake
  * rack        - https://github.com/rack/rack
  * rack-test   - https://github.com/brynary/rack-test
  * rspec       - https://github.com/rspec/rspec
  * tilt        - https://github.com/rtomayko/tilt

## Running the tests

You can run the tests from your command line client by typing `bundle exec rspec spec`.


##Limitations

This version of the gem does not implement callbacks, support migration generation and generating schema and has limited number of validations.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[andela-tfowotade]/hana.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


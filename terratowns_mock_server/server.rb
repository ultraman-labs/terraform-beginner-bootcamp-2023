require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

# We will mock having a state or database for this development server
# by setting a global variable. You would never use a global variable 
# in a production server. 
$home = {}

# This is a Ruby class that includes validation from ActiveRecord.
# This will represent our Home resources as a Ruby object.
class Home
  # ActiveModle is part of Ruby on rails.
  # It is used as an ORM (Object Relational Mapping). It has a module
  # within ActiveModle that provides validations.
  # The production Terratowns server is rails and uses
  # very similar and in most cases identical validation.
  # https://guides.rubyonrails.org/active_modle_basics.html
  # https://guides.rubyonrails.org/active_record_validations.html
  include ActiveModel::Validations

  # Create some virtual attributes to store on this object.
  # This well set a getter and setter
  # eg.
  # home = new Home()
  # home.town = 'hello' # setter
  # home.town() # getter
  

  attr_accessor :town, :name, :description, :domain_name, :content_version
  
  # gamers-groto
  # cooker-cove
  validates :town, presence: true, inclusion: { in: [
    'melomaniac-mansion',
    'cooker-cove',
    'video-valley',
    'the-nomad-pad',
    'gamers-groto'

  ] }
  # Visible to all users
  validates :name, presence: true
  # Visible to all users
  validates :description, presence: true
  # we want to lock this down to only cloudfront 
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 

  # content version has to be an integer
  # we will make sure it's an inctemental version in the  controler.  
  validates :content_version, numericality: { only_integer: true }
end

# We are extending a class from Sinatra::Base to 
# turn this generic class to utilize the Sinatra web-framework
class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end

  # return a hard coded access token
  def x_access_code
    return '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    return
    'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    # https://swagger.io/docs/specification/authentication/bearer-authentication/
    auth_header = request.env["HTTP_AUTHORIZATION"]
    # check if the AUTHORIZATION header exists.
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
    
    # does the token match the one in our database? 
    # if we can't find it or it doesn't match, then return an error
    # code = access_code = token
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
    
    # was there a user_uuid in the payload JSON?
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # the code and the user_uuid should be matching for user 
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    ensure_correct_headings
    find_user_by_bearer_token
    # puts will print to the terminal similar to a print or console.log
    puts "# create - POST /api/homes"

    # a begin is a try/catch if an error occurs, resuce it.
    begin
      # Sinatra does not automatically parse JSON bodies as params
      # like rails so we need to manually parse it.
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # assign payloads to variables 
    # to make it easier to work with the code
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]

    # printing the variables out to the console to make it easier
    # to see or debug what we have inputed into this endpoint.
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"

    # creating a new Home model and set attributes.
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
    # ensure our validation checks pass otherwise
    # return the errors
    unless home.valid?
      # return the error messages back as JSON
      error 422, home.errors.messages.to_json
    end

    # generating out a uuid at random
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    # we'll mock save our data to our mock database
    # which is just a global variable 
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }

    # we'll just return the user uuid
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    # does the uuid for the home match the one in our mock database
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  # very similar to create action
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    # delete from our mock database 
    $home = {}
    { message: "House deleted successfully" }.to_json
  end
end

# This is what will run the server.
TerraTownsMockServer.run!
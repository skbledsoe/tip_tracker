require "bundler/setup"
require "bcrypt"
require "bundler/setup"
require "date"
require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require "yaml"

require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
  set :erb, :escape_html => true
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end

helpers do
  def tip_total(tips)
    tips.empty? ? "0" : format("%.2f", tips.first[:overall_tips])
  end
end

def registered_user?(username, password)
  users = YAML.load_file("users.yml")
  
  if users.key?(username)
    bcrypt_password = BCrypt::Password.new(users[username])
    bcrypt_password == password
  else
    false
  end
end

def signed_in?
  session.key?(:username)
end

def require_signin
  unless signed_in?
    session[:url] = request.path_info
    redirect_with_error("/signin", "You must be signed in to do that.")
  end
end

def page_valid?(page, url)
  return [10, (page - 1) * 10] if page > 0
  
  redirect_with_error(url, "That page does not exist.")
end

def workplace_valid?(id)
  workplace = @storage.get_workplace(id)
  return workplace if workplace

  redirect_with_error("/workplaces", "That workplace does not exist.")
end

def shift_valid?(workplace_id, shift_id)
  shift = @storage.get_shift(workplace_id, shift_id)
  return shift if shift

  redirect_with_error("/workplaces/#{workplace_id}", "That shift does not exist.") 
end

def error_for_workplace(name)
  if @storage.workplace_names.any? { |workplace| workplace[:name].downcase == name.downcase }
    ["Please enter a unique list name."]
  elsif !(1..100).cover?(name.size)
    ["Please enter a name between 1 and 100 characters."]
  end
end

def errors_for_shift(date, type, tip_amount, id=nil)
  today = Date.today.iso8601
  shifts = @storage.all_shifts
  errors = []

  if shifts.any? { |shift| shift[:date] == date && shift[:type] == type && shift[:id] != id }
    errors << "#{type} shift already exists for #{date}."
  end

  errors << "Date must be between 2020-01-01 and #{today}" unless date.between?("2020-01-01", today)
  errors << "Shift type must be Morning, Afternoon, or Night." unless %w(Morning Afternoon Night).include?(type)
  errors << "Tip amount must be between $0.01 and $999.99" unless (0.01..999.99).cover?(tip_amount)
  
  errors
end

def redirect_with_error(url, error)
  session[:error] = [error]
  redirect url
end

before do
  @storage = DatabasePersistence.new(logger)
end

error 404 do
  redirect_with_error("/workplaces", "That page does not exist.")
end

get "/" do
  redirect "/workplaces"
end

get "/workplaces" do
  require_signin

  @page = params.fetch("page", 1).to_i
  per_page, offset = page_valid?(@page, "/workplaces")

  @workplaces = @storage.all_workplaces(per_page, offset)

  redirect_with_error("/workplaces", "That page does not exist.") if @workplaces.empty?

  erb :workplaces
end

get "/workplaces/add" do
  require_signin

  erb :add_workplace
end

post "/workplaces" do
  require_signin

  name = params[:workplace_name].strip

  error = error_for_workplace(name)

  if error 
    session[:error] = error
    erb :add_workplace
  else
    @storage.add_workplace(name)
    session[:success] = "#{name} has been added."
    redirect "/workplaces"
  end
end

get "/workplaces/:id" do
  require_signin

  id = params[:id].to_i
  @workplace = workplace_valid?(id)

  @page = params.fetch("page", 1).to_i
  per_page, offset = page_valid?(@page, "/workplaces/#{id}")

  @shifts = @storage.all_shifts_for_workplace(id, per_page, offset)

  erb :workplace
end

get "/workplaces/:id/edit" do
  require_signin

  id = params[:id].to_i
  @workplace = workplace_valid?(id)

  erb :edit_workplace
end

post "/workplaces/:id" do
  require_signin

  name = params[:workplace_name].strip
  id = params[:id].to_i

  @workplace = workplace_valid?(id)

  error = error_for_workplace(name)

  if error
    session[:error] = error
    erb :edit_workplace
  else
    @storage.update_workplace(id, name)
    session[:success] = "#{name} has been updated."
    redirect "/workplaces/#{id}"
  end
end

post "/workplaces/:id/delete" do
  require_signin

  id = params[:id].to_i
  @storage.delete_workplace(id)

  session[:success] = "Workplace has been deleted."
  redirect "/workplaces"
end

get "/workplaces/:id/shifts" do
  require_signin

  id = params[:id].to_i
  @workplace = workplace_valid?(id)

  erb :add_shift
end

post "/workplaces/:id/shifts" do
  require_signin

  id = params[:id].to_i
  @workplace = workplace_valid?(id)

  date = params[:date]
  type = params[:type].strip.capitalize
  tip_amount = params[:tip_amount].to_f

  errors = errors_for_shift(date, type, tip_amount)

  if errors.empty?
    @storage.add_shift(date, type, tip_amount, id)
    session[:success] = "Shift has been added."
    redirect "/workplaces/#{id}"
  else
    session[:error] = errors
    erb :add_shift
  end
end

post "/workplaces/:id/shifts/:shift_id/delete" do
  require_signin

  workplace_id = params[:id].to_i
  shift_id = params[:shift_id].to_i

  @storage.delete_shift(shift_id, workplace_id)

  session[:success] = "Shift has been deleted."
  redirect "/workplaces/#{workplace_id}"
end

get "/workplaces/:id/shifts/:shift_id" do
  require_signin

  workplace_id = params[:id].to_i
  @workplace = workplace_valid?(workplace_id)

  shift_id = params[:shift_id].to_i
  @shift = shift_valid?(workplace_id, shift_id)

  erb :edit_shift
end

post "/workplaces/:id/shifts/:shift_id" do
  require_signin

  workplace_id = params[:id].to_i
  @workplace = workplace_valid?(workplace_id)

  shift_id = params[:shift_id].to_i
  @shift = shift_valid?(workplace_id, shift_id)
  
  date = params[:date]
  type = params[:type].strip.capitalize
  tip_amount = params[:tip_amount].to_f

  errors = errors_for_shift(date, type, tip_amount, shift_id)

  if errors.empty?
    @storage.update_shift(date, type, tip_amount, shift_id, workplace_id)
    session[:success] = "Shift has been updated."
    redirect "/workplaces/#{workplace_id}"
  else
    session[:error] = errors
    erb :edit_shift
  end
end

get "/signin" do
  erb :signin
end

post "/signin" do
  username = params[:username]
  password = params[:password]

  if registered_user?(username, password)
    url = session.delete(:url)
    session[:username] = username
    session[:success] = "Welcome!"
    redirect url
  else
    session[:error] = ["Invalid Credentials"]
    erb :signin
  end
end

post "/signout" do
  require_signin

  session.delete(:username)
  session.delete(:password)
  session[:success] = "You have been signed out."

  redirect "/signin"
end

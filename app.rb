# Gems
require "require_all"
require "sinatra"
require "sequel"
enable :sessions

# So we can escape HTML special characters in the view
include ERB::Util

# App
require_rel "db/db", "models", "controllers"
# DB2 = Sequel.sqlite('db/test.sqlite3')

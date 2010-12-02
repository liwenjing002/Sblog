# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_per_blog_session',
  :secret      => '42a94d413992ca67e4b218effdecf3cab1ac8da4d8b2338004d3a2f4c1edf6fb5d6b1775ae830705602461691b62648bfad81091438bb84523a0a34565911611'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

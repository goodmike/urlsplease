# Devise signup uses recaptcha gem.
#
# Public and private keys must be set up in environment vars.
# Locally this is done, on a *nix system for example, by exporting the 
# variables in a shell login or profile file
#
# export RECAPTCHA_PUBLIC_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# export RECAPTCHA_PRIVATE_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
#
# For heroku, set the vars with the heroku gem's config:add option:
# > heroku config:add RECAPTCHA_PUBLIC_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# > heroku config:add RECAPTCHA_PRIVATE_KEY=yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

require 'recaptcha'

ActionView::Base.send(:include, Recaptcha::ClientHelper)
ActionController::Base.send(:include, Recaptcha::Verify)

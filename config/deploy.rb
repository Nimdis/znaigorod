require 'openteam/capistrano/recipes'

set :default_stage, 'production'
set :delayed_job_args, "-n 8"

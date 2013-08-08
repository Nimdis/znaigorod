set :branch, 'rf_affiche'

# do not run delayed_job on development stage
after 'deploy:restart', 'delayed_job:stop'

default_run_options[:pty] = true
set :application, "ghostcar"
set :scm, :git
set :repository, "git@github.com:infovore/ghostcar.git"
set :branch, "master"
set :deploy_to, "/var/www/rails/#{application}"
set :ssh_options, { :forward_agent => true }
set :port, 30000
set :user, "twra2"
set :use_sudo, false

# Default deploy target
ENV["TARGET"] ||= "production"

# For things that need to know their environment (db:migrate, etc)
set :rails_env, ENV["TARGET"]

case ENV["TARGET"]
when "production"
  set :domain, "turmeric"
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
end

default_run_options[:pty] = true
after "deploy:update_code", "symlink:db"

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

namespace :symlink do
  desc "Make copy of database yaml"
  task :db do
    sudo "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end
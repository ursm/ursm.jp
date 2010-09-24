require 'bundler/capistrano'

set :application, 'ursm.jp'

set :scm, :git
set :repository, File.expand_path('../..', __FILE__)
set :deploy_via, :copy

server 'macbook', :web, :app, :db, :primary => true
set :deploy_to, "/home/ursm/apps/#{application}"
set :use_sudo, false

namespace :deploy do
  def bluepill(*args)
    run "cd #{current_release} && bundle exec bluepill #{args.join(' ')} --base-dir=tmp/pids --no-privileged"
  end

  task :start, :roles => :app, :except => {:no_release => true} do
    bluepill "load config/#{application}.pill"
  end

  task :stop, :roles => :app, :except => {:no_release => true} do
    bluepill :stop
  end

  task :restart, :roles => :app, :except => {:no_release => true} do
    stop
    start
  end

  task :status do
    bluepill :status
  end
end

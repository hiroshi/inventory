set :application, "inventory"
set :repository,  "git://github.com/hiroshi/inventory"
set(:deploy_to) { "/var/www/#{target}" }
set :scm, :git
#set :branch, "master"
set :deploy_via, :remote_cache

namespace "demo.inventory.yakitara.com" do
  desc "set deploy target to demo.inventory.yakitara.com"
  task :default do
    set :target, task_call_frames.first.task.namespace.name
    server "silent.yakitara.com", :app, :web, :db, :primary => true
    set :user, "www-data"
    set :use_sudo, false
  end

  namespace :config do
    task :replace, :roles => :app do
      put <<-YML, "#{current_path}/config/database.yml"
production:
  adapter: postgresql
  encoding: unicode
  database: inventory_demo_production
  pool: 5
  username: www-data
  password:
      YML
    end
    after "deploy:update", "#{fully_qualified_name}:replace"
  end
end

task :foo do
  puts fetch(:rails_env, "production")
end

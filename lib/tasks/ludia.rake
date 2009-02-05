# Credits:
#  darashi: http://d.hatena.ne.jp/darashi/20071129/1196307189

# namespace :db do
#   namespace :test do
#     namespace :ludia do
#       task :install => :environment do
#         dbname = ActiveRecord::Base.configurations["test"]["database"]
#         sh "psql -f `pg_config --sharedir`/pgsenna2.sql #{dbname}"
#       end
#     end
#     task :clone => %w(test:ludia:install)
#     task :clone_structure => %w(test:ludia:install)
#   end
# end

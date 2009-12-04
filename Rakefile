# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

if ['gems:bundle', 'gems:build'].include?(ARGV.first) or
  /\Adeploy:/ =~ ARGV.first
  namespace :gems do
    desc 'Run gem bundle command.'
    task :bundle do
      config_file  = File.join(File.dirname(__FILE__), 'Gemfile')
      options_file = File.join(File.dirname(__FILE__), 'config/build_options.yml')
      unless system("gem bundle --cached -m #{config_file} -b #{options_file} --only production --only load_in_environment_rb")
        puts "Gem bundle failed!"
        exit 1
      end
    end

    desc 'Override gems:build.'
    task :build => :bundle
  end

  desc "Copy config/database.yml.example to config/database.yml if database.yml doesn't exist"
  file 'config/database.yml' => 'config/database.yml.example' do |t|
    cp t.prerequisites.first, t.name
  end

  desc "Copy config/thin.example.yml to config/database.yml if thin.yml doesn't exist"
  file 'config/thin.yml' => 'config/thin.yml.example' do |t|
    app_root = File.expand_path File.dirname(__FILE__)
    File.open(t.name, 'w') { |f|
      f << File.read(t.prerequisites.first).sub(/^(\s*chdir:\s*).+/, "\\1#{app_root}")
    }
  end

  namespace :deploy do
    desc 'Get everything ready to run the app.'
    task :prepare do
      ENV['RAILS_ENV'] = 'production'

      %w[gems:build config/database.yml].each { |task|
        Rake::Task[task].invoke
      }
    end

    desc 'Get everything ready to run the app.'
    task :prepare_to_run => :prepare do
      %w[db:create db:migrate].each { |task|
        sh "rake #{task}"
      }
    end

    desc 'Run (start or restart) the app.'
    task :run => :prepare_to_run do
      Rake::Task['config/thin.yml'].invoke
      sh 'script/gems/thin restart -C config/thin.yml'
    end

    desc 'Stop the app.'
    task :stop do
      sh 'script/gems/thin stop -C config/thin.yml'
    end
  end
else
  require(File.join(File.dirname(__FILE__), 'config', 'boot'))

  require 'rake'
  require 'rake/testtask'
  require 'rake/rdoctask'

  require 'tasks/rails'

  # In order to make these tasks to be showed when run `rake -T`
  namespace :gems do
    desc 'Run gem bundle command.'
    task :bundle
  end

  desc "Copy config/database.yml.example to config/database.yml if database.yml doesn't exist"
  file 'config/database.yml' => 'config/database.yml.example'

  desc "Copy config/thin.example.yml to config/database.yml if thin.yml doesn't exist"
  file 'config/thin.yml' => 'config/thin.example.yml'

  namespace :deploy do
    desc 'Get everything ready to run the app.'
    task :prepare

    desc 'Get everything ready to run the app.'
    task :prepare_to_run

    desc 'Run (start or restart) the app.'
    task :run => :prepare_to_run
  end

  def enable_record_sql
    class << ActiveRecord::Base.connection
      def execute_with_record_sql sql, *args, &blk
        File.open('db/migration.sql', 'a') { |f| f << "#{sql};\n" }
        execute_without_record_sql sql, *args, &blk
      end

      alias_method_chain :execute, :record_sql
    end
  end

  namespace :db do
    desc "Run db:migrate and record the sql script in db/migration.sql."
    task :migrate_and_record => :environment do
      enable_record_sql
      Rake::Task['db:migrate'].invoke
    end
  end
end

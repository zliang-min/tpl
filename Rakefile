# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

if ['gems:bundle', 'gems:build'].include?(ARGV.first) or
  /\Adeploy:/ =~ ARGV.first
  namespace :gems do
    desc 'Run gem bundle command.'
    task :bundle do
      config_file = File.join(File.dirname(__FILE__), 'Gemfile')
      unless system("gem bundle --cached -m #{config_file}")
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

      %w[db:create db:migrate].each { |task|
        sh "rake #{task}"
      }
    end

    desc 'Run (start or restart) the app.'
    task :run => :prepare do
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

    desc 'Run (start or restart) the app.'
    task :run => :prepare
  end
end

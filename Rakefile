# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

if ARGV.first == 'gems:bundle'
  namespace :gems do
    desc 'Run gem bundle command.'
    task :bundle do
      config_file = File.join(File.dirname(__FILE__), 'Gemfile')
      unless system("gem bundle --cached -m #{config_file}")
        puts "Gem bundle failed!"
        exit 1
      end
    end
  end
else
  require(File.join(File.dirname(__FILE__), 'config', 'boot'))

  require 'rake'
  require 'rake/testtask'
  require 'rake/rdoctask'

  require 'tasks/rails'

  # In order to make gems:bundle to be showed when run `rake -T`
  namespace :gems do
    desc 'Run gem bundle command.'
    task :bundle
  end
end

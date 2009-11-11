clear_sources
bundle_path "vendor/bundled_gems"

source "http://gemcutter.org"
#source "http://gems.rubyforge.org"
source "http://gems.github.com"

disable_system_gems

gem 'rack', '>= 1.0.1'
gem 'rails', '2.3.4'

gem 'mysql', except: :test
gem 'activerecord', '2.3.4' # require here or paperclip cannot find ActiveRecord!!
gem 'thoughtbot-paperclip', '>= 2.3.1', :require_as => 'paperclip'
gem 'state_machine', '>= 0.8.0'
#gem 'matthuhiggins-foreigner', '>= 0.2.1', require_as: 'foreigner', only: :install

gem 'haml', '>= 2.2.10'
gem 'compass', '>= 0.8.17'
gem 'mime-types', '>= 1.16', :require_as => 'mime/types'
gem 'bluecloth', '>= 2.0.5'

gem 'devise', '>= 0.4.3', :only => :load_in_environment_rb

only :test do
  gem 'sqlite3-ruby', '>= 1.2.5', require_as: 'sqlite3'
  gem 'thoughtbot-shoulda', '>= 2.10.2', require_as: 'shoulda'
  gem 'machinist', '>= 1.0.5', require_as: ['machinist/active_record', 'sham']
end

bin_path "script/gems"

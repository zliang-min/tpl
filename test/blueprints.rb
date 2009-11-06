Dir[File.join(File.dirname(__FILE__), 'fixtures/**/*.rb')].each { |bp|
  require bp
}

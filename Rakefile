$LOAD_PATH << './lib'
require 'json'
require 'erb'

system('bundle', 'install', '--quiet')

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  print "Unable to load rspec/core/rake_task, spec tests missing\n"
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)
rescue LoadError
  print "Unable to load rubocop/rake_task, rubocop tests missing\n"
end

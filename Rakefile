require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rom/fmp/version"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "get version"
task :version do
	puts ROM::FMP::VERSION
end
require 'rubygems'
require 'rake'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

begin
  require 'spec/rake/spectask'
  desc 'Test the gem.'
  Spec::Rake::SpecTask.new(:test) do |t|
    t.spec_files = FileList.new('spec/**/*_spec.rb')
  end
rescue LoadError
  tast :test do
    STDERR.puts "You must have rspec >= 1.3.0 to run the tests"
  end
end

desc 'Generate documentation for the gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.options << '--title' << 'Async Methods' << '--line-numbers' << '--inline-source' << '--main' << 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "async_methods"
    gem.summary = %Q{Gem that adds asynchronous method calls for all methods on every object to aid in throughput on I/O bound processes.}
    gem.description = %Q(Gem that adds asynchronous method calls for all methods on every object to aid in throughput on I/O bound processes. This is intended to improve throughput on I/O bound processes like making several HTTP calls in row.)
    gem.email = "brian@embellishedvisions.com"
    gem.homepage = "http://github.com/bdurand/acts_as_revisionable"
    gem.authors = ["Brian Durand"]
    gem.rdoc_options = ["--charset=UTF-8", "--main", "README.rdoc"]
    
    gem.add_development_dependency('rspec', '>= 1.3.0')
    gem.add_development_dependency('jeweler')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
end


# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{async_methods}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Durand"]
  s.date = %q{2011-01-24}
  s.description = %q{Gem that adds asynchronous method calls for all methods on every object to aid in throughput on I/O bound processes. This is intended to improve throughput on I/O bound processes like making several HTTP calls in row.}
  s.email = %q{brian@embellishedvisions.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "async_methods.gemspec",
    "lib/async_methods.rb",
    "lib/async_methods/async_methods.rb",
    "spec/async_method_spec.rb",
    "spec/method_tester.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/bdurand/async_methods}
  s.rdoc_options = ["--charset=UTF-8", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{Gem that adds asynchronous method calls for all methods on every object to aid in throughput on I/O bound processes.}
  s.test_files = [
    "spec/async_method_spec.rb",
    "spec/method_tester.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end


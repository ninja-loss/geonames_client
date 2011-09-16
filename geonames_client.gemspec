# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "geonames_client/version"

Gem::Specification.new do |s|
  s.name        = "geonames_client"
  s.version     = GeonamesClient::VERSION
  s.authors     = ["C. Jason Harrelson"]
  s.email       = ["jason@lookforwardenterprises.com"]
  s.homepage    = ""
  s.summary     = %q{A client to consume the geonames web services.}
  s.description = %q{A client to consume the geonames web services (www.geonames.org).}

  s.rubyforge_project = "geonames_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  development_dependencies = {
    %q<rake>     => [">= 0.9.2"],
    %q<rspec>    => [">= 2.6.0"],
    %q<httparty> => [">= 0.8.0"]
  }

  runtime_dependencies = {
    %q<httparty> => [">= 0.8.0"]
  }

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      development_dependencies.each do |name, versions|
        s.add_development_dependency( name, versions )
      end

      runtime_dependencies.each do |name, versions|
        s.add_runtime_dependency( name, versions )
      end
    else
      development_dependencies.each do |name, versions|
        s.add_dependency( name, versions )
      end

      runtime_dependencies.each do |name, versions|
        s.add_dependency( name, versions )
      end
    end
  else
    development_dependencies.each do |name, versions|
      s.add_dependency( name, versions )
    end

    runtime_dependencies.each do |name, versions|
      s.add_dependency( name, versions )
    end
  end
end

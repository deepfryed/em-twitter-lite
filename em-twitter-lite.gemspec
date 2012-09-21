# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "em-twitter-lite"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bharanee Rathna"]
  s.date = "2012-09-22"
  s.description = "Yet another eventmachine based twitter client (with em-synchrony)"
  s.email = ["deepfryed@gmail.com"]
  s.files = ["lib/em/twitter.rb", "README.md", "CHANGELOG"]
  s.homepage = "http://github.com/deepfryed/em-twitter-lite"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Yet another eventmachine based twitter client"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<em-http-request>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<simple_oauth>, [">= 0"])
      s.add_runtime_dependency(%q<em-synchrony>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<em-http-request>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<simple_oauth>, [">= 0"])
      s.add_dependency(%q<em-synchrony>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<em-http-request>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<simple_oauth>, [">= 0"])
    s.add_dependency(%q<em-synchrony>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end

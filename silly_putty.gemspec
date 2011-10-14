# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "silly_putty/version"

Gem::Specification.new do |s|
  s.name        = "silly_putty"
  s.version     = SillyPutty::VERSION
  s.authors     = ["Sunny Gleason"]
  s.email       = ["sunny.gleason@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "silly_putty"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

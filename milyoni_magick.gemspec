# -*- encoding: utf-8 -*-
require File.expand_path('../lib/milyoni_magick/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "milyoni_magick"
  gem.version       = MilyoniMagick::VERSION
  gem.authors       = ["Ryan Venegas", "Roger Graves"]
  gem.email         = %q{"devs@milyoni.com"}
  gem.description   = %q{wrapper for imagemagick}
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  #gem.add_development_dependency "rspec"
end

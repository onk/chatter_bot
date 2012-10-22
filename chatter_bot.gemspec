# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chatter_bot/version'

Gem::Specification.new do |gem|
  gem.name          = "chatter_bot"
  gem.version       = ChatterBot::VERSION
  gem.authors       = ["onk"]
  gem.email         = ["takafumi.onaka@gmail.com"]
  gem.description   = "chatter_bot"
  gem.summary       = "chatter_bot"
  gem.homepage      = "https://github.com/onk/chatter_bot"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "pit"
  gem.add_dependency "databasedotcom"
  gem.add_dependency "activerecord"
  gem.add_dependency "mysql2"
  gem.add_dependency "rake"
end


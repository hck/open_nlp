# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'open_nlp/version'

Gem::Specification.new do |gem|
  gem.name          = "open_nlp"
  gem.version       = OpenNlp::VERSION
  gem.authors       = ["Hck"]
  gem.description   = %q{JRuby tools wrapper for Apache OpenNLP}
  gem.summary       = %q{A JRuby wrapper for the Apache OpenNLP tools library}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.platform = "java"
end

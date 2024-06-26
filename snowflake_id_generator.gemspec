# snowflake_id_generator.gemspec
# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'snowflake_id_generator'
  spec.version       = 1.3
  spec.authors       = ['kokorolx']
  spec.email         = ['kokoro.lehoang@gmail.com']
  spec.summary       = 'Snowflake ID generator and analyzer service.'
  spec.description   = 'Generate unique Snowflake IDs across multiple data centers and workers simultaneously using a distributed system.'
  spec.homepage      = 'https://github.com/kokorolx/snowflake_id_generator'
  spec.license       = 'MIT'

  # Specify gem files to include
  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.require_paths = ['lib']
end

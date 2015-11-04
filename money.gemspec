require File.expand_path('../lib/money/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['lekealem']
  gem.email         = ['lekealemasong@yahoo.de']
  gem.description   = 'Currency converter gem.'
  gem.summary       = 'Currency conversion and arithmetics.'
  gem.homepage      = 'https://github.com/lasong/money'
  gem.licenses      = 'MIT'

  gem.files         = Dir['lib/**/*'] + %w(LICENSE Rackfile README.md)
  gem.test_files    = Dir['spec/**/*']
  gem.name          = 'money'
  gem.require_paths = ['lib']
  gem.version       = Money::VERSION

  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.4'
end

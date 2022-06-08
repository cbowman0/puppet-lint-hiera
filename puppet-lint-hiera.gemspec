Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-hiera'
  spec.version     = '0.0.2'
  spec.author      = 'Garrett Rowell'
  spec.email       = 'garrett@puppet.com'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'puppet-lint hiera and lookup function checks'
  spec.description = <<-EOF
    Extends puppet-lint to ensure no hiera functions are called and that lookups are only used in class parameters.
  EOF

  spec.add_dependency             'puppet-lint', '>= 1.1', '< 3.0'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.0'
  spec.add_development_dependency 'rake', '~> 13.0.0'
  spec.add_development_dependency 'rspec-json_expectations', '~> 2.2'
  spec.add_development_dependency 'simplecov', '~> 0.18.0'
end

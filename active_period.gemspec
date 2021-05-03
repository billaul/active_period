lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_period/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_period'
  spec.version       = ActivePeriod::VERSION
  spec.authors       = ['billau_l']

  spec.summary       = 'Manage time ranges without brain damage.'
  # spec.description   = "Period.new('01/01/2020'..Time.now)"
  spec.homepage      = "https://github.com/billaul/period"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["bug_tracker_uri"]   = spec.homepage + '/issues'
    spec.metadata["homepage_uri"]      = spec.homepage
    spec.metadata["documentation_uri"] = spec.homepage
    spec.metadata["source_code_uri"]   = spec.homepage
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib config]

  spec.required_ruby_version = '>= 2.7'
  spec.add_runtime_dependency 'activesupport', '~> 5'
  spec.add_runtime_dependency 'i18n', '~> 1'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end

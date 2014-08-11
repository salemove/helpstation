lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'helpstation/version'

Gem::Specification.new do |spec|
  spec.name          = 'helpstation'
  spec.version       = Helpstation::VERSION
  spec.authors       = ['Indrek Juhkam']
  spec.email         = ['indrek@salemove.com']
  spec.description   = %q{Helps to unify SaleMove services}
  spec.summary       = %q{}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'substation', '~> 0.0', '>= 0.0.10'
end

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'tdriver/version'

@__release_mode = ENV['rel_mode']
@__release_mode = 'minor' if @__release_mode == nil
@__gem_version = read_version

Gem::Specification.new do |spec|
  spec.platform     = Gem::Platform::RUBY
  spec.name         = "cutedriver_driver"
  spec.version      = @__gem_version
  spec.author       = "Testability Driver team & cuTeDriver team"
  spec.email        = "antti.korventausta@nomovok.com"
  spec.homepage     = "https://github.com/nomovok-opensource/cutedriver-driver"
  spec.summary      = "cuTeDriver version of TDriver Testability Driver"
  spec.license      = "LGPL-2.1"

  spec.bindir       = "bin/"
  spec.executables  = ['tdriver-devtools', 'start_app_perf']

  spec.files        = Dir[
    'README.md',
    'lib/*.rb',
    'lib/tdriver/*.rb',
    'lib/tdriver/base/**/*',
    'lib/tdriver/sut/**/*',
    'lib/tdriver/verify/**/*',
    'lib/tdriver/report/**/*',
    'lib/tdriver/util/**/*',
    'lib/tdriver-devtools/**/*',
    'xml/**/*',
    'bin/**/*',
    'ext/**/*',
    'config/**/*'
  ]

#  spec.require_path = "lib/."
  spec.has_rdoc     = false
  spec.extensions << 'ext/extconf.rb'
end

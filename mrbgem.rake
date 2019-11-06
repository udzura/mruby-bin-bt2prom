MRuby::Gem::Specification.new('mruby-bin-bt2prom') do |spec|
  require_relative 'mrblib/bt2prom.rb'

  spec.version = Bt2Prom::VERSION

  spec.bins = ['bt2prom']
  spec.license = 'MIT'
  spec.authors = 'Uchio Kondo'
end

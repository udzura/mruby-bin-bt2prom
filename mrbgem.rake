MRuby::Gem::Specification.new('mruby-bin-bt2prom') do |spec|
  require_relative 'mrblib/bt2prom.rb'

  spec.version = Bt2Prom::VERSION

  spec.bins = ['bt2prom']
  spec.license = 'MIT'
  spec.authors = 'Uchio Kondo'

  def spec.core_gem(gemname)
    self.add_dependency gemname, core: gemname
  end

  def spec.mgem(gemname)
    self.add_dependency gemname, mgem: gemname
  end

  def spec.github_gem(repofullname, opts={})
    self.add_dependency repofullname.split('/').last, opts.merge(github: repofullname)
  end

  spec.core_gem 'mruby-io'
  spec.core_gem 'mruby-array-ext'
  spec.core_gem 'mruby-hash-ext'
  spec.core_gem 'mruby-enum-ext'
  spec.mgem 'mruby-json'
  spec.mgem 'mruby-onig-regexp'
  spec.mgem 'mruby-env'
  spec.mgem 'mruby-catch-throw'
  spec.github_gem 'fastly/mruby-optparse'
end

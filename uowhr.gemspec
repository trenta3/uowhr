DIR = File.dirname(__FILE__)
LIB = File.join(DIR, *%w[lib whole_history_rating.rb])
VERSION = open(LIB) { |lib|
  lib.each { |line|
    if v = line[/^\s*VERSION\s*=\s*(['"])(\d+\.\d+\.\d+)\1/, 2]
      break v
    end
  }
}

SPEC = Gem::Specification.new do |s|
  s.name = "uowhr"
  s.version = VERSION
  s.platform = Gem::Platform::RUBY

  #s.add_dependency('json', '>= 1.5.0')

  #s.add_development_dependency "rspec"

  #s.executables = ['whr_rate']

  s.files = `git ls-files`.split("\n")
  s.require_paths = %w[lib]
end

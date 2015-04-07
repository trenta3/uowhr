DIR = File.dirname(__FILE__)
LIB = File.join(DIR, *%w[lib uowhr.rb])
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
  s.authors = ["Dario Balboni"]
  s.email = ["dario.balboni@email.it"]
  s.homepage = "http://github.com/trenta3/uowhr"
  s.summary = "A pure ruby implementation of Remi Coulom's Whole-History Rating algorithm."
  s.description = <<-END_DESCRIPTION.gsub(/\s+/, " ").strip
  This gem provides a library and executables that take as input as set of games and output a set of skill rankings for the players of those games.  The algorithm is a version of Remi Coulom's Whole-History Rating and implemented in Ruby. 
  END_DESCRIPTION
  #s.add_dependency('json', '>= 1.5.0')

  #s.add_development_dependency "rspec"

  #s.executables = ['whr_rate']

  s.files = `git ls-files`.split("\n")
  s.require_paths = %w[lib]
end

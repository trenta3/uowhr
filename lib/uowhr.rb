require 'rubygems'

module UOwhr

  VERSION = "0.0.1"

  STDOUT.sync = true

  ROOT = File.expand_path(File.dirname(__FILE__))

  %w[ base
      player
      game
      player_day
  ].each do |lib|
    require File.join(ROOT, 'uowhr', lib)
  end

end

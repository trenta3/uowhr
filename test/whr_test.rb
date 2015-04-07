require 'uowhr'
require 'csv'

@whr = UOwhr::Base.new ({:w2 => 40})

sfide = CSV.read("Sfide.txt").map {|x| [Date.parse(x[0]), x[1], x[2], Float(x[3]), Float(x[4])]}
startdate = Date.parse "2014-07-25"

playerslist = sfide.map {|x| x[1]} | sfide.map {|x| x[2]}

# WholeHistoryRating::Base#create_game arguments: equal player name, opposite player name, outcome, day number
sfide.each do |(data, giocug, giocop, puntiug, puntiop)|
	#puts "Gioco: #{giocug} vs #{giocop} - #{puntiug} a #{puntiop}, #{puntiug / (puntiug + puntiop)}, giorno #{(data - startdate).to_i}"
	@whr.create_game(giocug, giocop, puntiug / (puntiug + puntiop), (data - startdate).to_i)
end
# Iterate the WHR algorithm towards convergence with more players/games, more iterations are needed.
@whr.iterate(50)

# Results are stored in one triplet for each day: [day_number, elo_rating, uncertainty]
playerslist.each do |player|
	puts "#{player}: " + @whr.ratings_for_player(player).last.to_s
end





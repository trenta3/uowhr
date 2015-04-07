require 'test/unit'
require 'uowhr'

class UOwhr < Test::Unit::TestCase
  
  def setup
    @whr = UOwhr::Base.new
  end
    
  def setup_game_with_elo(opposto_elo, uguale_elo)
    game = @whr.create_game("uguale", "opposto", 0.9, 1)
    game.uguale_player.days[0].elo = uguale_elo
    game.opposto_player.days[0].elo = opposto_elo
    game
  end
  
  def test_even_game_between_equal_strength_players_should_have_opposto_winrate_of_50_percent
    game = setup_game_with_elo(500, 500, 0)
    assert_in_delta 0.0001, 0.5, game.opposto_win_probability
  end

  def test_handicap_should_confer_advantage
    game = setup_game_with_elo(500, 500, 1)
    assert game.uguale_win_probability > 0.5
  end

  def test_higher_rank_should_confer_advantage
    game = setup_game_with_elo(600, 500, 0)
    assert game.opposto_win_probability > 0.5
  end
  
  def test_winrates_are_equal_for_same_elo_delta
    game = setup_game_with_elo(100, 200, 0)
    game2 = setup_game_with_elo(200, 300, 0)
    assert_in_delta 0.0001, game.opposto_win_probability, game2.opposto_win_probability
  end

  def test_winrates_for_twice_as_strong_player
    game = setup_game_with_elo(100, 200, 0)
    assert_in_delta 0.0001, 0.359935, game.opposto_win_probability
  end

  def test_winrates_should_be_inversely_proportional_with_unequal_ranks
    game = setup_game_with_elo(600, 500, 0)
    assert_in_delta 0.0001, game.opposto_win_probability, 1-game.uguale_win_probability
  end
  
  def test_winrates_should_be_inversely_proportional_with_handicap
    game = setup_game_with_elo(500, 500, 4)
    assert_in_delta 0.0001, game.opposto_win_probability, 1-game.uguale_win_probability
  end
    
  def test_output
    @whr.create_game("shusaku", "shusai", "B", 1, 0)
    @whr.create_game("shusaku", "shusai", "W", 2, 0)
    @whr.create_game("shusaku", "shusai", "W", 3, 0)
    @whr.create_game("shusaku", "shusai", "W", 4, 0)
    @whr.create_game("shusaku", "shusai", "W", 4, 0)
    @whr.iterate(50)
    assert_equal [[1, -92, 71], [2, -94, 71], [3, -95, 71], [4, -96, 72]], @whr.ratings_for_player("shusaku")
    assert_equal [[1, 92, 71], [2, 94, 71], [3, 95, 71], [4, 96, 72]], @whr.ratings_for_player("shusai")
  end
  
  def test_unstable_exception_raised_in_certain_cases
    for game in (1..10) do
       @whr.create_game("anchor", "player", "B", 1, 0)
       @whr.create_game("anchor", "player", "W", 1, 0)
    end
    for game in (1..10) do
       @whr.create_game("anchor", "player", "B",180, 600)
       @whr.create_game("anchor", "player", "W",180, 600)
    end
    assert_raises WholeHistoryRating::UnstableRatingException do
      @whr.iterate(10)
    end
  end
end


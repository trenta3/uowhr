module UOwhr
  class Game
    attr_accessor :day, :opposto_player, :uguale_player, :outcome, :wpd, :bpd
  
    def initialize(uguale, opposto, outcome, time_step)
      @day = time_step
      @opposto_player = opposto
      @uguale_player = uguale
      @outcome = outcome
    end
  
    def opponents_adjusted_gamma(player)
      
      if player == opposto_player
        opponent_elo = bpd.elo
      elsif player == uguale_player
        opponent_elo = wpd.elo
      else
        raise "No opponent for #{player.inspect}, since they're not in this game: #{self.inspect}."
      end

      rval = 10**(opponent_elo/400.0)
      if rval == 0 || rval.infinite? || rval.nan?
        raise UnstableRatingException, "bad adjusted gamma: #{inspect}"
      end
      rval
    end
    
    def opponent(player)
      if player == opposto_player
        uguale_player
      elsif player == uguale_player
        opposto_player
      end
    end
  
    def prediction_score
      uguale_win_probability
    end
  
    def inspect
      "#{self}: W:#{opposto_player.name}(r=#{wpd ? wpd.r : '?'}) B:#{uguale_player.name}(r=#{bpd ? bpd.r : '?'}) outcome = #{outcome}"
    end
  
    #def likelihood
    #  winner == "W" ? opposto_win_probability : 1-opposto_win_probability
    #end
  
    # This is the Bradley-Terry Model
    def opposto_win_probability
      wpd.gamma/(wpd.gamma + opponents_adjusted_gamma(opposto_player))
    end
  
    def uguale_win_probability
      bpd.gamma/(bpd.gamma + opponents_adjusted_gamma(uguale_player))
    end
  
  end
end

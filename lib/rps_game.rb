# require_relative "./artificial_player"
class RpsGame
  attr_reader :players, :round

  CHOICES = { :rock =>     [:scissors, :lizard], 
              :scissors => [:paper, :lizard], 
              :paper =>    [:rock, :spock],
              :spock =>    [:rock, :scissors],
              :lizard =>   [:spock, :paper] }
  CHOICES.default = []
  
  def initialize(player1, player2)
    @players = [player1, player2]
    @round = 0
  end
  
  class << self
    attr_reader :current_game
    def create_game(player1, player2)
      @current_game = RpsGame.new(player1, player2)
    end
  end

  def multiplayer? # should I require artificial player class for that?
    !player2.instance_of?(ArtificialPlayer)
  end

  def make_bot_choose
    player2.chooses(nil)
  end

  def decide_winner
    return set_round_results(player1, player2) if player1_wins?
    return set_round_results(player2, player1) if player2_wins?
    return set_round_results # draw game
  end
  
  def display_final_results
    "#{player1.name}: #{player1.win_counts} wins <br> #{player2.name}: #{player2.win_counts} wins"
  end

  def player1
    players.first
  end

  def player2
    players.last
  end

  def increase_round_counter
    @round += 1
  end

  def reset_round_counter
    @round = 0
  end

  def multiplayer_link
    return multiplayer? && round % 2 == 1 ? "/play" : "/results"
  end

  private
  def player1_choice 
    player1.turn_choice
  end

  def player2_choice
    player2.turn_choice
  end

  def player1_wins?
    CHOICES[player1_choice].include?(player2_choice)
  end

  def player2_wins?
    CHOICES[player2_choice].include?(player1_choice) 
  end

  def set_round_results(winner = nil, looser = nil)
    return "It's a DRAW..." if winner.nil?
    winner.wins
    "#{winner.name} with #{winner.turn_choice} won #{looser.name} with #{looser.turn_choice}"
  end
end

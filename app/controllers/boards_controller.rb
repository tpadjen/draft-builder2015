class BoardsController < LeaguesViewController
  around_action :skip_bullet

  def draft
  	@players = @league.draft_picks.selected
                  .includes(nfl_player: :fantasy_teams)
                  .order(:number)
                  .map(&:nfl_player)
    @rounds = @players.each_slice(@league.size)
    @klass = 'draft'
    @board_name = 'Draft'
    set_render
  end

  def adp_ffc
  	@players = load_players.order(:adp_ffc)
    @rounds = @players.each_slice(@league.size)
    @klass = 'adp'
    @board_name = 'FFC ADP'
    set_render
  end

  def adp_espn
    @players = load_players.order(:adp_espn)
    @rounds = @players.each_slice(@league.size)
    @klass = 'adp'
    @board_name = 'ESPN ADP'
    set_render
  end

  def adp_yahoo
    @players = load_players.order(:adp_yahoo)
    @rounds = @players.each_slice(@league.size)
    @klass = 'adp'
    @board_name = 'Yahoo ADP'
    set_render
  end

  def points
  	@players = load_players.order(projected_points: :desc)
    @rounds = @players.each_slice(@league.size)
    @klass = 'points'
    @board_name = 'Projected Points'    
    set_render
  end

  private

    def load_players
      NflPlayer.all.includes(:leagues)
    end

    def set_render
      render 'board'
    end
end

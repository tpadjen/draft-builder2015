class LeaguesViewController < ApplicationController
	layout 'leagues_view'

	before_action :set_league
	before_action :set_draft_picks
  before_action :set_positions
  before_action :set_fantasy_teams

  def current_pick
    @league.draft_picks.unselected.first
  end

  private

  	def set_league
      @league = League.find(params[:league_id])
    end

  	def set_draft_picks
  		@draft_picks = @league.draft_picks.includes(:fantasy_team).includes(:nfl_player).order(:number)
  		@current_pick = current_pick
  	end

  	def set_positions
      @positions = NflPlayer::VALID_POSITIONS.clone.unshift('All')
    end

    def set_fantasy_teams
      @fantasy_teams = @league.fantasy_teams.order(:pick_number)
    end
	
end
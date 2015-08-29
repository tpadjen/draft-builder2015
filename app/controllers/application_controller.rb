class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_draft_picks
  before_action :set_positions
  before_action :set_fantasy_teams

  def current_pick
    DraftPick.unselected.first
  end

  def skip_bullet
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = true
  end

  private

  	def set_draft_picks
  		@draft_picks = DraftPick.all.includes(:fantasy_team).includes(:nfl_player).order(:number)
  		@current_pick = current_pick
  	end

  	def set_positions
      @positions = NflPlayer::VALID_POSITIONS.clone.unshift('All')
    end

    def set_fantasy_teams
      @fantasy_teams = FantasyTeam.all.order(:pick_number)
    end
end

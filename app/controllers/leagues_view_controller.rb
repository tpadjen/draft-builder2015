class LeaguesViewController < ApplicationController
	layout 'leagues_view'

	before_action :set_league
	before_action :set_draft_picks
  before_action :set_positions
  before_action :set_fantasy_teams

  def edit_teams
    @teams = @league.fantasy_teams.order(:pick_number)
    render 'leagues/edit_teams'
  end

  def update_teams
    respond_to do |format|
      if @league.update(team_params)
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html do
          @teams = @league.fantasy_teams.order(:pick_number)
          render 'leagues/edit_teams' 
        end
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def current_pick
      @league.draft_picks.unselected.first
    end

  	def set_league
      @league = League.find(params[:league_id])
    end

  	def set_draft_picks
      @draft_picks = @league.draft_picks.includes([:fantasy_team, :nfl_player]).order(:number)
  		@current_pick = current_pick
      @limited_positions = @current_pick.fantasy_team.limited_positions
  	end

  	def set_positions
      @positions = NflPlayer::VALID_POSITIONS.clone.unshift('All')
    end

    def set_fantasy_teams
      @fantasy_teams = @league.fantasy_teams.order(:pick_number)
    end

    def team_params
      params.require(:league).permit(fantasy_teams_attributes: [:owner, :id])
    end
	
end
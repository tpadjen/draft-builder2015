require 'uri'

class DraftPicksController < LeaguesViewController

  def pick
    if !@current_pick
      render json: "Draft over", status: 401
    else
    	if params[:player] && player = NflPlayer.find(params[:player][:id].to_i)
    		if @current_pick.update(nfl_player: player, league_id: params[:league_id])
    			render json: {
    				current_pick: @current_pick.to_json, 
    				next_pick: current_pick.to_json,
            limited_positions: current_pick.fantasy_team.limited_positions
          }, status: 200
    		else
    			render json: @current_pick.errors, status: :unprocessable_entity
    		end
    	end
    end
  end

  def undo
    puts request.referer
    if @league.draft_picks.order(:number).first.selected?
      pick = @league.draft_picks.selected.where.not(keeper: true).order(:number).last
      player = pick.nfl_player
      prev_team = pick.fantasy_team
      owner = pick.fantasy_team.owner
      prev_pick = pick.to_json
      prev_pick[:picks_left] = (prev_pick[:picks_left].to_i + 1).to_s
      pick.update(nfl_player: nil)
      message = "#{owner}'s selection of #{player.name} has been undone."

      respond_to do |format|
        format.html do
          flash[:success] = message
          redirect_to :back   
        end
        format.json do
          html = nil
          if request.referer.include? '/team/' # on a team's page
            ref_owner = URI.decode(request.referer.partition('/team/').last)
            if owner.downcase == ref_owner.downcase # on the changed page
              html = {}
              fantasy_team = FantasyTeam.from_owner(owner, @league)
              @picks, @starters, @bench = fantasy_team.roster
               
              with_format :html do
                html[:picks] = render_to_string partial: 'fantasy_teams/picks_table'
                html[:roster] = render_to_string partial: 'fantasy_teams/roster_table'
              end
            end
          end

          render json: {
            html: html,
            message: message,
            current_pick: @current_pick.to_json, 
            prev_pick: prev_pick,
            limited_positions: prev_team.limited_positions
          }, status: 200 
        end
      end
      
    else
      message = "No picks have been made."
      respond_to do |format|
        format.html do
          flash[:error] = message
          redirect_to :back    
        end
        format.json do
          render json: message, status: :unprocessable_entity
        end
      end
      
    end
  end

end

require 'uri'

class DraftPicksController < LeaguesViewController

  def pick
    if !@current_pick
      render json: "Draft over", status: 401
    else
    	if params[:player] && player = NflPlayer.find(params[:player][:id].to_i)
    		if @current_pick.update(nfl_player: player)
    			render json: {
    				current_pick: @current_pick.to_json, 
    				next_pick: current_pick.to_json 
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
      owner = pick.fantasy_team.owner
      prev_pick = pick.to_json
      pick.update(nfl_player: nil)
      message = "#{owner}'s selection of #{player.name} has been undone."

      respond_to do |format|
        format.html do
          flash[:success] = message
          redirect_to :back   
        end
        format.json do
          team_html = nil
          if request.referer.include? '/team/' # on a team's page
            ref_owner = URI.decode(request.referer.partition('/team/').last)
            if owner.downcase == ref_owner.downcase
              params = {
                league_id: @league.id, 
                owner: URI.decode(request.referer.partition('/team/').last)
              }
              request.format = :html
              team_html = renderActionInOtherController(FantasyTeamsController, :show, params)
              request.format = :json
            end
          end

          render json: {
            team_html: team_html,
            message: message,
            current_pick: @current_pick.to_json, 
            prev_pick: prev_pick
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

  private

    def renderActionInOtherController(controller,action,params)
      c = controller.new
      c.params = params
      c.dispatch(action, request)
      c.process_action(action)
      c.response.body
    end

end

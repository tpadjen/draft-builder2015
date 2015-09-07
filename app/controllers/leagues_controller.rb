class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]

  def current_pick
    DraftPick.unselected.first
  end

  # GET /leagues
  # GET /leagues.json
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    redirect_to league_draft_board_path(@league)
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(league_params)

    respond_to do |format|
      if @league.save

        (0..(@league.size-1)).each_with_index do |i|
          fantasy_team = @league.fantasy_teams.create(owner: "Team #{i+1}", pick_number: i+1)
          picks = []

          (1..@league.roster_size).each do |round|
            offset = round % 2 == 1 ? i + 1: @league.size - i
            pick = (round-1)*@league.size + offset
            @league.draft_picks.create(number: pick, fantasy_team: fantasy_team)
          end

          puts "Team #{i} gets picks #{fantasy_team.draft_picks.map(&:number)}\n"
        end

        format.html { redirect_to @league, notice: 'League was successfully created.' }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to leagues_path, notice: 'League was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league.fantasy_teams.delete_all
    @league.draft_picks.delete_all
    @league.destroy
    respond_to do |format|
      format.html { redirect_to leagues_url, notice: 'League was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_params
      params.require(:league).permit(:name, :size, :roster_style)
    end
end

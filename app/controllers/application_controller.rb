class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_draft_picks

  private

  	def set_draft_picks
  		@draft_picks = DraftPick.all.order(:number)
  	end
end

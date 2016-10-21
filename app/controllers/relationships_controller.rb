class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @person = User.find(params[:followed_id])
    current_user.follow(@person)
    respond_to do |format|
      format.html { redirect_to @person }
      format.js
    end
  end
  
  def destroy
    @person = Relationship.find(params[:id]).followed
    current_user.unfollow(@person)
    respond_to do |format|
      format.html { redirect_to @person }
      format.js
    end
  end
end

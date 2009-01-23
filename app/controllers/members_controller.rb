class MembersController < ApplicationController
  before_filter :login_required

  def index
    @users = current_user.group.users
  end

  def new
    @user = current_user.group.users.build

    render :action => "show"
  end

  def create
    @user = current_user.group.users.build(params[:user])
    if @user.save
      redirect_to members_path
    else
      render :action => "show"
    end
  end
end

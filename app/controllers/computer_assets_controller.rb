class ComputerAssetsController < ApplicationController
  before_filter :login_required
  before_filter :new_computer_asset, :only => [:new, :create]
  before_filter :set_computer_asset, :only => [:show, :update]
  # FIXME
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_computer_asset_developer_name]

  def index
    # TODO: refactor and generalize as find 
    options = {:include => :developer, :order => "computer_assets.id ASC"}
    if user_id = params[:user_id]
      options[:joins] = "LEFT JOIN utilizations u ON u.computer_asset_id = computer_assets.id"
      options[:conditions] = ["u.user_id = ?", user_id]
    end
    @computer_assets = current_group.computer_assets.find(:all, options)
  end

  def new
    render :action => "show"
  end

  def create
    @computer_asset.save!
    redirect_to computer_assets_path
  end

  def show
#    @utilizations = Utilization.find(:all, :from => "utilization_revisions", :conditions => ["id = ?", @computer_asset.utilization], :order => "revision DESC")
    @utilizations = @computer_asset.utilization.revisions
  end

  def update
    ActiveRecord::Base.transaction do
      @computer_asset.update_attributes!(params[:computer_asset])
      @computer_asset.utilization.update_attributes!(params[:utilization])
    end

    redirect_to computer_assets_path
  end

  # TODO: to be a REST action
  def auto_complete_for_computer_asset_developer_name
    name = params[:computer_asset]["developer_name"]
    # OPTIMIZE: regexp or like can be expensive (cause full table search), instead use fulltext search if possible
    # @developers = Developer.find(:all, :conditions => ["name LIKE ?", "%#{name}%"])
    @developers = Developer.find(:all, :conditions => ["name ~* ?", name])
    if @developers.blank?
      render :nothing => true
    else
      render :inline => "<%= content_tag :ul, @developers.map {|d| content_tag(:li, h(d.name))} %>" 
    end
  end

  private

  def new_computer_asset
    @computer_asset = current_group.computer_assets.build(params[:computer_asset])
    # @computer_asset.group_id = current_user.group_id
    @computer_asset.build_utilization(params[:utilization])
  end

  def set_computer_asset
    @computer_asset = current_user.group.computer_assets.find_by_id(params[:id]) or raise NotFoundError
  end
end

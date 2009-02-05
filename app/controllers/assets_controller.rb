class AssetsController < ApplicationController
  before_filter :login_required
  before_filter :new_asset, :only => [:new, :create]
  before_filter :set_asset, :only => [:show, :update, :destroy]
  # FIXME
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_asset_developer_name]

  def index
    @assets = current_group.assets.params_scope(params)
  end

  def new
    render :action => "show"
  end

  def create
    if @asset.valid? && @utilization.valid?
      @asset.save!
      redirect_to assets_path
    else
      render :action => "show"
    end
  end

  def show
#    @utilizations = Utilization.find(:all, :from => "utilization_revisions", :conditions => ["id = ?", @asset.utilization], :order => "revision DESC")
#    @utilizations = @utilization.revisions
    @utilizations = @asset.utilizations
  end
  
  def update
    if @asset.valid? && @utilization.valid?
      ActiveRecord::Base.transaction do
        # replace utilization if user is altered
        if Utilization.new(params[:utilization]).user_id != @asset.utilization.user_id
          @asset.utilization = current_group.utilizations.build(params[:utilization])
          @utilization.asset = @asset
        else
          @utilization.update_attributes!(params[:utilization])
        end
        @asset.update_attributes!(params[:asset])
      end
      redirect_to assets_path
    else
      render :action => "show"
    end
  end

  def destroy
    @asset.destroy
    redirect_to assets_path
  end

  # TODO: to be a REST action
  def auto_complete_for_asset_developer_name
    name = params[:asset]["developer_name"]
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

  def new_asset
    @asset = current_group.assets.build(params[:asset])
    @asset.utilization = @utilization = current_group.utilizations.build(params[:utilization])
    @utilization.asset = @asset
  end

  def set_asset
    @asset = current_user.group.assets.find_by_id(params[:id]) or raise NotFoundError
    @utilization = @asset.utilization || @asset.build_utilization
  end
end

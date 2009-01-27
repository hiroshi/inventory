class Utilization < ActiveRecord::Base
  acts_as_tree
  belongs_to :asset
  belongs_to :user

  belongs_to :group
  before_validation do |utilization|
    utilization.group_id ||= utilization.asset.try(:group_id)
  end

  include Revision::Model

  named_scope :include_asset, :include => :asset
#  named_scope :include_asset_and_user, :include => [:asset, :user]
end

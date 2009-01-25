class Utilization < ActiveRecord::Base
  acts_as_tree
  belongs_to :computer_asset
  belongs_to :user

  belongs_to :group
  before_validation do |utilization|
    utilization.group_id ||= utilization.computer_asset.try(:group_id)
  end

  include Revision::Model

  named_scope :include_asset, :include => :computer_asset
#  named_scope :include_asset_and_user, :include => [:computer_asset, :user]
end

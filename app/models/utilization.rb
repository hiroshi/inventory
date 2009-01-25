class Utilization < ActiveRecord::Base
  acts_as_tree
  belongs_to :computer_asset
  belongs_to :user

  include Revision::Model

  named_scope :include_asset, :include => :computer_asset
#  named_scope :include_asset_and_user, :include => [:computer_asset, :user]
end

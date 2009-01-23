class ComputerAsset < ActiveRecord::Base
  # developer
  belongs_to :developer
  # TODO: may be separated as "smart delegate"
  smart_delegate :developer, :name, :strip_spaces => true

  # group
  belongs_to :group

  has_one :utilization, :order => "created_at DESC"
#  has_many :utilization_histories
end

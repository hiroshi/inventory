class ComputerAsset < ActiveRecord::Base
  # developer
  belongs_to :developer
  validates_presence_of :developer_name
  smart_delegate :developer, :name, :strip_spaces => true

  # group
  belongs_to :group

  # utilization
  has_one :utilization, :order => "created_at DESC", :dependent => :destroy
#  validates_associated :utilization
end

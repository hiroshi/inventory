class Asset < ActiveRecord::Base
  # developer
  belongs_to :developer
  validates_presence_of :developer_name
  smart_delegate :developer, :name, :strip_spaces => true

  # group
  belongs_to :group

  # utilization
  has_many :utilizations, :order => "started_on DESC", :dependent => :destroy
  has_one :utilization, :order => "started_on DESC" # means "current"
end

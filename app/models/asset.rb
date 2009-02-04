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

  # scopes
  named_scope :user_id, lambda{|user_id|
    {:conditions => ["(SELECT user_id FROM utilizations WHERE asset_id = assets.id ORDER BY started_on DESC LIMIT 1) = ?", user_id]}
  }
  named_scope :developer_name, lambda{|developer_name|
    {:joins => :developer, :conditions => ["developers.name %% ?", developer_name]}
  }
end

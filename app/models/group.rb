class Group < ActiveRecord::Base
  has_many :users
  has_many :computer_assets
  has_many :utilizations
end

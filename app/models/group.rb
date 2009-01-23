class Group < ActiveRecord::Base
  has_many :users
  has_many :computer_assets
end

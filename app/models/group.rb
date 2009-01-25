class Group < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :computer_assets, :dependent => :destroy
  has_many :utilizations
end

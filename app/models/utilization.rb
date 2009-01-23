class Utilization < ActiveRecord::Base
  belongs_to :computer_asset
  belongs_to :user

  include Revision::Model
end

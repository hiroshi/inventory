require 'test_helper'

class ComputerAssetTest < ActiveSupport::TestCase
  test "developer_name" do
    # test setter and getter
    assert_equal 0, Developer.count(:conditions => {:name => "Apple"})
    asset = ComputerAsset.create!(:group => groups(:one), :developer_name => "Apple")
    assert_equal "Apple", asset.developer_name
    assert_equal 1, Developer.count(:conditions => {:name => "Apple"})
    asset = ComputerAsset.find(asset.id)
    assert_equal "Apple", asset.developer_name
  end
end

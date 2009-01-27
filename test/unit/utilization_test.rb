require 'test_helper'

class UtilizationTest < ActiveSupport::TestCase
  test "revisions" do
    utilization = Utilization.create!(:asset => Asset.create!(:product_name => "PC", :model_number => "A1", :group => groups(:one), :developer_name => "Anon"))
    assert_equal 1, utilization.revisions.size
  end
end

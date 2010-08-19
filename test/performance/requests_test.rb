require 'test_helper'
require 'rails/performance_test_help'

class RequestsTest < ActionDispatch::PerformanceTest
     
  # Replace this with your real tests.
  def test_listing_all_requests
    get '/'
  end
  
end

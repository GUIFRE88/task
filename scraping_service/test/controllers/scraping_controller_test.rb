require "test_helper"

class ScrapingControllerTest < ActionDispatch::IntegrationTest
  test "should get start_scraping" do
    get scraping_start_scraping_url
    assert_response :success
  end
end

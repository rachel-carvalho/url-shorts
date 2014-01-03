require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @url = create(:url, user: @user)
  end

  test 'url belongs to user' do
    assert_equal @url.user, @user
  end

  test 'numeric id increment' do
    previous_num = @url.num_id

    u = create(:url, user: @user)

    assert_equal u.num_id, previous_num + 1
  end

  test 'short is generated from numeric id' do
    shortened = Url.bijective_encode @url.num_id

    assert_equal @url.short, shortened
  end

  test 'shortened url reverses to numeric id' do
    reversed = Url.bijective_decode @url.short

    assert_equal @url.num_id, reversed
  end

  test '`clicked!` increments click count' do
    count = @url.clicks
    @url.clicked!
    assert_equal @url.clicks, count + 1
  end
end

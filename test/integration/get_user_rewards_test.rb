require 'test_helper'

class GetUserRewardsTest < ActionDispatch::IntegrationTest
  test 'get rewards for known eligible user with rewards' do
    EligibilityService.stubs(:is_user_eligible?).with('32').returns('CUSTOMER_ELIGIBLE')
    get '/v1/user_rewards/32?channels=MOVIES,SPORTS', {}, {'Authorization'=> valid_token}
    assert_equal 200, response.status
    refute_empty response.body

    assert_includes rewards, "PIRATES_OF_THE_CARIBBEAN_COLLECTION"
    assert_includes rewards, "CHAMPIONS_LEAGUE_FINAL_TICKET"
    assert_equal 2, rewards.count

  end

  test 'get unauthorized for known eligible user with rewards but invalid token' do
    EligibilityService.stubs(:is_user_eligible?).with('32').returns('CUSTOMER_ELIGIBLE')
    get '/v1/user_rewards/32?channels=MOVIES,SPORTS', {}, {'Authorization'=> invalid_token}
    assert_equal 401, response.status
    assert_equal json['error'], 'The authentication token was not recognised..'

  end

  test 'get no invalid rewards for known eligible user with rewards' do
    EligibilityService.stubs(:is_user_eligible?).with('36').returns('CUSTOMER_ELIGIBLE')
    get '/v1/user_rewards/36?channels=MOVIES,SPORTS,MUSIC,KIDS,NEWS', {}, {'Authorization'=> valid_token}
    assert_equal 200, response.status
    refute_empty response.body

    assert_includes rewards, "PIRATES_OF_THE_CARIBBEAN_COLLECTION"
    assert_includes rewards, "CHAMPIONS_LEAGUE_FINAL_TICKET"
    assert_includes rewards, "KARAOKE_PRO_MICROPHONE"
    assert_equal 3, rewards.count
    refute_includes rewards, "NONE"

  end

  test 'get rewards for known eligible user with no rewards' do
    EligibilityService.stubs(:is_user_eligible?).with('4').returns('CUSTOMER_ELIGIBLE')
    get '/v1/user_rewards/4?channels=KIDS', {}, {'Authorization'=> valid_token}
    assert_equal 200, response.status
    refute_empty response.body

    assert_equal 0, json.count
  end

  test 'get no rewards for known eligible user with unknown channel' do
    EligibilityService.stubs(:is_user_eligible?).with('8').returns('CUSTOMER_ELIGIBLE')
    get '/v1/user_rewards/8?channels=COMEDY', {}, {'Authorization'=> valid_token}
    assert_equal 200, response.status
    refute_empty response.body

    assert_equal 0, json.count
  end

  test 'get no rewards for known ineligible user' do
    EligibilityService.stubs(:is_user_eligible?).with('1').returns('CUSTOMER_INELIGIBLE')
    get '/v1/user_rewards/1?channels=MOVIES,SPORTS', {}, {'Authorization'=> valid_token}
    assert_equal 200, response.status
    refute_empty response.body

    assert_equal 0, json.count
  end

  test 'get error for unknown user' do
    EligibilityService.stubs(:is_user_eligible?).with('3').raises(EligibilityService::InvalidAccountNumberException)
    get '/v1/user_rewards/3?channels=MOVIES,SPORTS', {}, {'Authorization'=> valid_token}
    assert_equal 422, response.status
    refute_empty response.body

    assert_equal json['error'], 'This user account number is not recognised.'
  end

  test 'get error when technical failure' do
    EligibilityService.stubs(:is_user_eligible?).with('2').raises(EligibilityService::TechnicalFailureException)
    get '/v1/user_rewards/2?channels=MOVIES,SPORTS', {}, {'Authorization'=> valid_token}
    assert_equal 500, response.status
    refute_empty response.body

    reward_response = JSON.parse(response.body)
    assert_equal 0, reward_response.values.count
  end

end
